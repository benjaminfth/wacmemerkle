// testMerkleAirdrop.js
const { ethers } = require("ethers");
require('dotenv').config();
// Sepolia RPC URL and private key of the claimant
const provider = new ethers.JsonRpcProvider("https://eth-sepolia.g.alchemy.com/v2/UpILRzssL8NhMTCYnGOM2pUZgSpY8HSd");

const wallet = new ethers.Wallet(process.env.DEPLOYER_KEY, provider);

// MerkleAirdrop contract details
const airdropAddress = process.env.AIRDROP_CONTRACT_ADDRESS;
const airdropAbi = [
  // Minimal ABI for claim and balanceOf
  "function claim(address account, uint256 amount, bytes32[] calldata proof) external",
];

// ChakkaToken contract details (for balance check)
const tokenAddress = process.env.TOKEN_CONTRACT_ADDRESS;
const tokenAbi = [
  "function balanceOf(address account) view returns (uint256)"
];

// Claim data from input.json
const user = process.env.CLAIM_ACCOUNT;
const amount = ethers.parseUnits("25", 18);

const proof = [
  process.env.PROOF_ONE,
  process.env.PROOF_TWO,
  process.env.PROOF_THREE,
  process.env.PROOF_FOUR,
  process.env.PROOF_FIVE,
  process.env.PROOF_SIX,
  process.env.PROOF_SEVEN
];

async function main() {
  const airdrop = new ethers.Contract(airdropAddress, airdropAbi, wallet);
  const token = new ethers.Contract(tokenAddress, tokenAbi, provider);

  // Check balance before claim
  const before = await token.balanceOf(user);
  console.log("Balance before claim:", ethers.formatUnits(before, 18));

  // Send claim transaction
  const tx = await airdrop.claim(user, amount, proof);
  console.log("Claim tx sent:", tx.hash);
  await tx.wait();
  console.log("Claim confirmed!");

  // Check balance after claim
  const after = await token.balanceOf(user);
  console.log("Balance after claim:", ethers.formatUnits(after, 18));
}

main().catch(console.error);