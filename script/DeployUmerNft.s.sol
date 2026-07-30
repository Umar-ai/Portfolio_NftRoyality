//SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { UmerNft } from "../src/UmerNft.sol";
import { Script } from "forge-std/Script.sol";

contract DeployUmerNft is Script {
    function run() public returns (UmerNft, string[] memory) {
        uint256 royalityFraction = 7;
        string[] memory tokenUris = parseTokenUris();
        vm.startBroadcast();
        address royalityReceiver = msg.sender;
        UmerNft umerNft = new UmerNft(tokenUris, royalityReceiver, royalityFraction);
        vm.stopBroadcast();
        return (umerNft, tokenUris);
    }

    function parseTokenUris() public view returns (string[] memory tokenUris) {
        string memory json = vm.readFile("script/TokenUri.json");
        tokenUris = vm.parseJsonStringArray(json, "");
    }
}
