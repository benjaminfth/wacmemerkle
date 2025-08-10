// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {ChakkaToken} from "src/ChakkaToken.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";

contract DeployMerkle is Script {
    uint256 public constant AIRDROP_TOTAL = 25 ether * 100;

    function run() external {
        uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        bytes32 merkleRoot = vm.envBytes32("MERKLE_ROOT");
        require(merkleRoot != bytes32(0), "MERKLE_ROOT not set");

        vm.startBroadcast(deployerKey);

        ChakkaToken token = new ChakkaToken();
        console.log("ChakkaToken deployed:", address(token));

        MerkleAirdrop airdrop = new MerkleAirdrop(merkleRoot, token);
        console.log("MerkleAirdrop deployed:", address(airdrop));

        token.mint(address(airdrop), AIRDROP_TOTAL);
        console.log("Funded airdrop with:", AIRDROP_TOTAL);

        // // Conditional verify (skips if no api key set)
        // string memory apiKey = vm.envOr("ETHERSCAN_API_KEY", string(""));
        // if (bytes(apiKey).length > 0) {
        //     vm.verifyContract(address(token), "src/ChakkaToken.sol:ChakkaToken");
        //     vm.verifyContract(address(airdrop), "src/MerkleAirdrop.sol:MerkleAirdrop");
        //     console.log("Submitted verification");
        // } else {
        //     console.log("Skip verification (ETHERSCAN_API_KEY missing)");
        // }

        vm.stopBroadcast();
    }
}
