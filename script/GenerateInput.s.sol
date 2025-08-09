// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

// Merkle tree input file generator script
contract GenerateInput is Script {
    uint256 private constant AMOUNT = 25 * 1e18;
    string[] types = new string[](2);
    uint256 count;
    string[] whitelist = new string[](100);
    string private constant INPUT_PATH = "/script/target/input.json";

    function run() public {
        types[0] = "address";
        types[1] = "uint";
        // Fill whitelist with 100 addresses
        whitelist[0] = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
        whitelist[1] = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
        whitelist[2] = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";
        whitelist[3] = "0x90F79bf6EB2c4f870365E785982E1f101E93b906";
        whitelist[4] = "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65";
        whitelist[5] = "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc";
        whitelist[6] = "0x976EA74026E726554dB657fA54763abd0C3a0aa9";
        whitelist[7] = "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955";
        whitelist[8] = "0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f";
        whitelist[9] = "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720";
        whitelist[10] = "0xBcd4042DE499D14e55001CcbB24a551F3b954096";
        whitelist[11] = "0x71bE63f3384f5fb98995898A86B02Fb2426c5788";
        whitelist[12] = "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a";
        whitelist[13] = "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec";
        whitelist[14] = "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097";
        whitelist[15] = "0xcd3B766CCDd6AE721141F452C550Ca635964ce71";
        whitelist[16] = "0x2546BcD3c84621e976D8185a91A922aE77ECEc30";
        whitelist[17] = "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E";
        whitelist[18] = "0xdD2FD4581271e230360230F9337D5c0430Bf44C0";
        whitelist[19] = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
        whitelist[20] = "0x09DB0a93B389bEF724429898f539AEB7ac2Dd55f";
        whitelist[21] = "0x02484cb50AAC86Eae85610D6f4Bf026f30f6627D";
        whitelist[22] = "0x08135Da0A343E492FA2d4282F2AE34c6c5CC1BbE";
        whitelist[23] = "0x5E661B79FE2D3F6cE70F5AAC07d8Cd9abb2743F1";
        whitelist[24] = "0x61097BA76cD906d2ba4FD106E757f7Eb455fc295";
        whitelist[25] = "0xDf37F81dAAD2b0327A0A50003740e1C935C70913";
        whitelist[26] = "0x553BC17A05702530097c3677091C5BB47a3a7931";
        whitelist[27] = "0x87BdCE72c06C21cd96219BD8521bDF1F42C78b5e";
        whitelist[28] = "0x40Fc963A729c542424cD800349a7E4Ecc4896624";
        whitelist[29] = "0x9DCCe783B6464611f38631e6C851bf441907c710";
        whitelist[30] = "0x1BcB8e569EedAb4668e55145Cfeaf190902d3CF2";
        whitelist[31] = "0x8263Fce86B1b78F95Ab4dae11907d8AF88f841e7";
        whitelist[32] = "0xcF2d5b3cBb4D7bF04e3F7bFa8e27081B52191f91";
        whitelist[33] = "0x86c53Eb85D0B7548fea5C4B4F82b4205C8f6Ac18";
        whitelist[34] = "0x1aac82773CB722166D7dA0d5b0FA35B0307dD99D";
        whitelist[35] = "0x2f4f06d218E426344CFE1A83D53dAd806994D325";
        whitelist[36] = "0x1003ff39d25F2Ab16dBCc18EcE05a9B6154f65F4";
        whitelist[37] = "0x9eAF5590f2c84912A08de97FA28d0529361Deb9E";
        whitelist[38] = "0x11e8F3eA3C6FcF12EcfF2722d75CEFC539c51a1C";
        whitelist[39] = "0x7D86687F980A56b832e9378952B738b614A99dc6";
        whitelist[40] = "0x9eF6c02FB2ECc446146E05F1fF687a788a8BF76d";
        whitelist[41] = "0x08A2DE6F3528319123b25935C92888B16db8913E";
        whitelist[42] = "0xe141C82D99D85098e03E1a1cC1CdE676556fDdE0";
        whitelist[43] = "0x4b23D303D9e3719D6CDf8d172Ea030F80509ea15";
        whitelist[44] = "0xC004e69C5C04A223463Ff32042dd36DabF63A25a";
        whitelist[45] = "0x5eb15C0992734B5e77c888D713b4FC67b3D679A2";
        whitelist[46] = "0x7Ebb637fd68c523613bE51aad27C35C4DB199B9c";
        whitelist[47] = "0x3c3E2E178C69D4baD964568415a0f0c84fd6320A";
        whitelist[48] = "0x35304262b9E87C00c430149f28dD154995d01207";
        whitelist[49] = "0xD4A1E660C916855229e1712090CcfD8a424A2E33";
        whitelist[50] = "0xEe7f6A930B29d7350498Af97f0F9672EaecbeeFf";
        whitelist[51] = "0x145e2dc5C8238d1bE628F87076A37d4a26a78544";
        whitelist[52] = "0xD6A098EbCc5f8Bd4e174D915C54486B077a34A51";
        whitelist[53] = "0x042a63149117602129B6922ecFe3111168C2C323";
        whitelist[54] = "0xa0EC9eE47802CeB56eb58ce80F3E41630B771b04";
        whitelist[55] = "0xe8B1ff302A740fD2C6e76B620d45508dAEc2DDFf";
        whitelist[56] = "0xAb707cb80e7de7C75d815B1A653433F3EEc44c74";
        whitelist[57] = "0x0d803cdeEe5990f22C2a8DF10A695D2312dA26CC";
        whitelist[58] = "0x1c87Bb9234aeC6aDc580EaE6C8B59558A4502220";
        whitelist[59] = "0x4779d18931B35540F84b0cd0e9633855B84df7b8";
        whitelist[60] = "0xC0543b0b980D8c834CBdF023b2d2A75b5f9D1909";
        whitelist[61] = "0x73B3074ac649A8dc31c2C90a124469456301a30F";
        whitelist[62] = "0x265188114EB5d5536BC8654d8e9710FE72C28c4d";
        whitelist[63] = "0x924Ba5Ce9f91ddED37b4ebf8c0dc82A40202fc0A";
        whitelist[64] = "0x64492E25C30031EDAD55E57cEA599CDB1F06dad1";
        whitelist[65] = "0x262595fa2a3A86adACDe208589614d483e3eF1C0";
        whitelist[66] = "0xDFd99099Fa13541a64AEe9AAd61c0dbf3D32D492";
        whitelist[67] = "0x63c3686EF31C03a641e2Ea8993A91Ea351e5891a";
        whitelist[68] = "0x9394cb5f737Bd3aCea7dcE90CA48DBd42801EE5d";
        whitelist[69] = "0x344dca30F5c5f74F2f13Dc1d48Ad3A9069d13Ad9";
        whitelist[70] = "0xF23E054D8b4D0BECFa22DeEF5632F27f781f8bf5";
        whitelist[71] = "0x6d69F301d1Da5C7818B5e61EECc745b30179C68b";
        whitelist[72] = "0xF0cE7BaB13C99bA0565f426508a7CD8f4C247E5a";
        whitelist[73] = "0x011bD5423C5F77b5a0789E27f922535fd76B688F";
        whitelist[74] = "0xD9065f27e9b706E5F7628e067cC00B288dddbF19";
        whitelist[75] = "0x54ccCeB38251C29b628ef8B00b3cAB97e7cAc7D5";
        whitelist[76] = "0xA1196426b41627ae75Ea7f7409E074BE97367da2";
        whitelist[77] = "0xE74cEf90b6CF1a77FEfAd731713e6f53e575C183";
        whitelist[78] = "0x7Df8Efa6d6F1CB5C4f36315e0AcB82b02Ae8BA40";
        whitelist[79] = "0x9E126C57330FA71556628e0aabd6B6B6783d99fA";
        whitelist[80] = "0x586BA39027A74e8D40E6626f89Ae97bA7f616644";
        whitelist[81] = "0x9A50ed082Cf2fc003152580dcDB320B834fA379E";
        whitelist[82] = "0xbc8183bac3E969042736f7af07f76223D11D2148";
        whitelist[83] = "0x586aF62EAe7F447D14D25f53918814e04d3A5BA4";
        whitelist[84] = "0xCcDd262f272Ee6C226266eEa13eE48D4d932Ce66";
        whitelist[85] = "0xF0eeDDC5e015d4c459590E01Dcc2f2FD1d2baac7";
        whitelist[86] = "0x4edFEDFf17ab9642F8464D6143900903dD21421a";
        whitelist[87] = "0x492C973C16E8aeC46f4d71716E91b05B245377C9";
        whitelist[88] = "0xE5D3ab6883b7e8c35c04675F28BB992Ca1129ee4";
        whitelist[89] = "0x71F280DEA6FC5a03790941Ad72956f545FeB7a52";
        whitelist[90] = "0xE77478D9E136D3643cFc6fef578Abf63F9Ab91B1";
        whitelist[91] = "0x6C8EA11559DFE79Ae3dBDD6A67b47F61b929398f";
        whitelist[92] = "0x48fA7b63049A6F4E7316EB2D9c5BDdA8933BCA2f";
        whitelist[93] = "0x16aDfbeFdEfD488C992086D472A4CA577a0e5e54";
        whitelist[94] = "0x225356FF5d64889D7364Be2c990f93a66298Ee8D";
        whitelist[95] = "0xcBDc0F9a4C38f1e010bD3B6e43598A55D1868c23";
        whitelist[96] = "0xBc5BdceE96b1BC47822C74e6f64186fbA7d686be";
        whitelist[97] = "0x0536896a5e38BbD59F3F369FF3682677965aBD19";
        whitelist[98] = "0xFE0f143FcAD5B561b1eD2AC960278A2F23559Ef9";
        whitelist[99] = "0x98D08079928FcCB30598c6C6382ABfd7dbFaA1cD";
        count = whitelist.length;
        string memory input = _createJSON();
        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);

        console.log("DONE: The output is found at %s", INPUT_PATH);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count); // convert count to string
        string memory amountString = vm.toString(AMOUNT); // convert amount to string
        string memory json = string.concat('{ "types": ["address", "uint"], "count":', countString, ',"values": {');
        for (uint256 i = 0; i < whitelist.length; i++) {
            if (i == whitelist.length - 1) {
                json = string.concat(json, '"', vm.toString(i), '"', ': { "0":', '"',whitelist[i],'"',', "1":', '"',amountString,'"', ' }');
            } else {
            json = string.concat(json, '"', vm.toString(i), '"', ': { "0":', '"',whitelist[i],'"',', "1":', '"',amountString,'"', ' },');
            }
        }
        json = string.concat(json, '} }');

        return json;
    }
}