// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperconfig = new HelperConfig();
        (address vrfCoordinator, bytes32 keyHash, uint64 subscriptionId, uint32 callbackGasLimit) =
            helperconfig.activeNetworkConfig();

        vm.startBroadcast();
        Raffle raffle = new Raffle(vrfCoordinator, keyHash, subscriptionId, callbackGasLimit);
        vm.stopBroadcast();

        return (raffle, helperconfig);
    }
}
