// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import {Script, console} from "forge-std/Script.sol";
import "../src/MultiSwap.sol";

contract DeployMultiSwap is Script {
    function run() external returns (MultiSwap) {
        vm.startBroadcast();

        MultiSwap multiSwap = new MultiSwap();

        vm.stopBroadcast();
        return multiSwap;
    }
}
