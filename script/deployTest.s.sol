pragma solidity ^0.8.24;
import { Script, console } from "forge-std/Script.sol";
import { test } from "../src/test.sol";

contract deployTest is Script {
    test public t;
    function run() public {
        vm.startBroadcast();
        t = new test();
        vm.stopBroadcast();
        console.log(address(t));
    }
}
