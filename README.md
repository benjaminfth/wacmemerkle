## Merkle Airdrop (Foundry)

This project demonstrates a complete ERC20 token + Merkle airdrop workflow using Foundry.

Components:
- ChakkaToken (ERC20, mintable by owner)
- MerkleAirdrop (allows one-time claims verified via a Merkle proof)
- Scripts to generate input data (whitelist + uniform amount) and deploy contracts

---
## Directory Structure
```
src/                Contracts (ChakkaToken.sol, MerkleAirdrop.sol)
script/             Foundry scripts (GenerateInput, DeployMerkle)
script/target/      Generated artifacts (input.json) [git-ignored recommended]
.test/ or test/     (Add your tests here)
README.md           Documentation
```

---
## Data Flow & Execution Order
1. Prepare whitelist (already hardcoded in GenerateInput.s.sol as sample Anvil addresses).
2. Run GenerateInput script to produce input.json (address => allocation mapping format required for Merkle tree generation).
3. Off-chain: Build Merkle tree from input.json (see specification below) and obtain MERKLE_ROOT.
4. Set environment variables (.env) for deployment (DEPLOYER_KEY, MERKLE_ROOT, optional ETHERSCAN_API_KEY).
5. Deploy contracts using DeployMerkle script.
6. Distribute claim instructions (amount + Merkle proof) to participants.
7. Users call claim() once; contract enforces single claim via s_hasClaimed mapping.

---
## Environment & Prerequisites
- Foundry (forge, cast, anvil) installed: https://book.getfoundry.sh/getting-started/installation
- Node.js (optional) if you build the Merkle tree with a JS utility.

Create a .env file (never commit real secrets):
```
DEPLOYER_KEY=0xYOUR_PRIVATE_KEY_HEX
MERKLE_ROOT=0x... # computed root
ETHERSCAN_API_KEY= # optional for verification
```
(Ensure .env is in .gitignore.)

---
## Security / Sensitive Data Notes
- No private keys, API keys, or secrets are hardcoded in the repo.
- Addresses in GenerateInput.s.sol are default Anvil test accounts (public, not sensitive).
- Deployment script only pulls secrets from environment variables via vm.env* helpers.
- Before committing, verify no secrets were added accidentally: git grep -i 'private key' / 'api key'.

---
## Generating input.json
Run (no broadcast needed; it only writes a file):
```
forge script script/GenerateInput.s.sol:GenerateInput
```
Output file: script/target/input.json

Format (excerpt):
```
{
  "types": ["address", "uint"],
  "count": 100,
  "values": {
    "0": { "0": "0x...addr0", "1": "25000000000000000000" },
    "1": { "0": "0x...addr1", "1": "25000000000000000000" },
    ...
  }
}
```
Meaning for each index i:
- values[i]."0" = address
- values[i]."1" = amount (uint256, 25 * 1e18 in this sample)

---
## Merkle Tree Specification
Leaf construction inside MerkleAirdrop:
```
leaf = keccak256( bytes.concat( keccak256( abi.encode(account, amount) ) ) );
```
(Effectively a double keccak: keccak256( keccak256(abi.encode(address, amount)) ).)

Tree: standard sorted pair hashing OR raw concatenation? (Contract uses MerkleProof.verify, which expects the conventional hashing of ordered siblings as provided by OpenZeppelin's MerkleProof. You must replicate identical ordering & hashing when building the tree.)

Recommendation (JS pseudocode using merkletreejs):
```
const { keccak256 } = require('ethers/lib/utils');
const { MerkleTree } = require('merkletreejs');

function leaf(account, amount) {
  const inner = keccak256(ethers.utils.defaultAbiCoder.encode(['address','uint256'], [account, amount]));
  return keccak256(inner); // double hash
}

const leaves = allocations.map(a => Buffer.from(leaf(a.address, a.amount).slice(2), 'hex'));
const tree = new MerkleTree(leaves, (data) => Buffer.from(keccak256(data).slice(2), 'hex'), { sortPairs: true });
const root = '0x' + tree.getRoot().toString('hex');
```
Set MERKLE_ROOT to this root.

---
## Deployment
Start a local chain (optional development):
```
anvil
```
Deploy (example to local Anvil):
```
source .env
forge script script/DeployMerkle.s.sol:DeployMerkle \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  -vv
```
For a public testnet (e.g. Sepolia), set --rpc-url and ensure DEPLOYER_KEY has funds.

(Optional) Contract verification (uncomment verification section in DeployMerkle.s.sol and provide ETHERSCAN_API_KEY).

---
## Post-Deployment
Record:
- Token address (console output)
- Airdrop contract address
- MERKLE_ROOT used

Fund check: Deploy script already mints AIRDROP_TOTAL (25 ether * 100) to the airdrop contract.

---
## Claiming
A claimer needs: (account, amount, merkleProof[])
Call:
```
cast send <MerkleAirdropAddress> "claim(address,uint256,bytes32[])" \
  <account> <amountWei> [proofElement1] [proofElement2] ... \
  --rpc-url <rpc> --private-key <claimer_key>
```
If successful, the Claim event is emitted and tokens transferred.

Errors:
- MerkleAirdrop__InvalidProof: wrong amount/address/proof ordering or root mismatch.
- MerkleAirdrop__AlreadyClaimed: address claimed before.

---
## Testing Suggestions
Add tests (e.g., in test/MerkleAirdrop.t.sol):
- Correct claim succeeds.
- Double claim reverts.
- Invalid proof reverts.
- Partial tree tampering fails verification.

Run:
```
forge test -vvv
```

---
## Common Pitfalls
- Mismatch in leaf hashing (ensure double keccak as described).
- Using non-sorted leaves vs sorted pairs; set sortPairs: true if you adopted that during root generation.
- Forgetting to update MERKLE_ROOT after regenerating whitelist/allocation.
- Committing .env (avoid; ensure .gitignore has .env).

---
## Maintenance / Extensibility
- To vary individual allocations, modify GenerateInput to store per-address amounts before JSON serialization.
- To reduce on-chain gas, you can pack (address, uint96) if amounts fit and adjust encoding.
- Add a deadline or pausable modifier for operational control if desired.

---
## Cleanup
If you regenerate input:
1. Rerun GenerateInput
2. Recompute root
3. Update .env MERKLE_ROOT
4. (Re)deploy if necessary

---
## Original Foundry Quick Reference
```
forge build
forge test
forge fmt
forge snapshot
anvil
cast --help
```
