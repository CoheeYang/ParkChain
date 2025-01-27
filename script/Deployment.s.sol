// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import { Script, console } from "forge-std/Script.sol";
import { ParkLotToken } from "../src/ParkLotToken.sol";
import { Issuer } from "../src/Issuer.sol"; // Ensure the path and contract name are correct
import { MockFunctionRouters } from "../src/mocks/MockFunctionRouters.sol";
import { NetWorkConfig } from "./NetWorkConfig.s.sol";

contract Deployment is NetWorkConfig {
    string public sourceCode = vm.readFile("src_function/sourceCode.js");
    Issuer public issuer;
    ParkLotToken public parkLotToken;
    NetWorkParams public networkParams;

    function run() public returns (MockFunctionRouters, ParkLotToken, Issuer) {
        networkParams = NetWorkMapping[block.chainid];
        vm.startBroadcast();
        parkLotToken = new ParkLotToken("");
        issuer = new Issuer(address(parkLotToken), networkParams.functionRouter, sourceCode);

        if (block.chainid == LOCAL_CHAIN_ID) {
            parkLotToken.setIssuer(address(issuer));
        }
        // else {
        //     ParkLotToken pl = ParkLotToken(address(parkLotToken));
        //     pl.setIssuer(address(issuer));
        // } not a valid way to call the function
        vm.stopBroadcast();

        console.log("current Chain ID: ", block.chainid);
        console.log("MockFunctionRouters address: ", address(mockFunctionRouters));
        console.log("ParkLotToken address: ", address(parkLotToken));
        console.log("Issuer address: ", address(issuer));

        return (mockFunctionRouters, parkLotToken, issuer);
    }
}
