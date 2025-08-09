//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {ChakkaToken} from "../src/ChakkaToken.sol";
import {console} from "forge-std/console.sol";

contract MerkleAirdropTest is Test {

    MerkleAirdrop public airdrop;
    ChakkaToken public token;

    bytes32 public ROOT = 0x80e634131b130b5e425f5e76ffa70779a3faa20a430ba2fecd1680704c8a51ff; // Example Merkle root, replace with actual root
    address  user = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Example owner address
    uint256 userPrivKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 AMOUNT_TO_CLAIM = 25 * 1e18; // Example amount
    uint256 AMOUNT_TO_SEND = AMOUNT_TO_CLAIM*4; // Example amount to claim
    bytes32 proofOne = 0xf884e61898c71567fd4f44aa020453ed544cb775949e2087043630858aa9e609;
    bytes32 proofTwo = 0xf19a9e842b5a96e6e829203e375dfae8688610006eff2ecee5b1d5171631c970;
    bytes32 proofThree = 0xc7ea0e7a5122c7e558bd639ac163854d8dfde2099d7889fe28127629854a217c;
    bytes32 proofFour = 0x981717fef2cf159d965ad7937f660439ffb9cb7bf6c0ca334321c4396c92cadd;
    bytes32 proofFive = 0x4940b19bedd64461dfcf6cdee9eba8f757f1eb973b8d5861fb6dd2f92cc1e432;
    bytes32 proofSix = 0x59d9f24b657b80649c8344960983513d80f1de1d2f9eebe3a5599859ebe9b5d4;
    bytes32 proofSeven = 0x98396762bc70ed815edc1c3106bf68d1d032e4238d590cb7194fb262fc4310aa;
    bytes32[] PROOF = [proofOne, proofTwo, proofThree, proofFour, proofFive, proofSix, proofSeven];
    
    function setUp() public {
        // Deploy the token contract
        token = new ChakkaToken();
        
        
        // Deploy the Merkle Airdrop contract
        airdrop = new MerkleAirdrop(ROOT, token);
        
        // Mint tokens to the owner for the airdrop
        token.mint(token.owner(), AMOUNT_TO_SEND);
        // Transfer tokens to the airdrop contract
        token.transfer(address(airdrop), AMOUNT_TO_SEND);

    }
    function testUserCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);
        vm.prank(user);
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);
        uint256 endingBalance = token.balanceOf(user);
        console.log("User balance after claim: ", endingBalance);
        assertEq(endingBalance, startingBalance + AMOUNT_TO_CLAIM, "User should receive the claimed amount");
    }
}