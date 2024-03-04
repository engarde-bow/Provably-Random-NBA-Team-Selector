// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Raffle is VRFConsumerBaseV2 {
    //Errors//
    error somethingwentwrong();

    uint256[] pastWinners;

    //NBA Teams//
    string hawks = "Atlanta Hawks";
    string celtics = "Boston Celtics";
    string nets = "Brooklyn Nets";
    string hornets = "Charlotte Hornets";
    string bulls = "Chicago Bulls";
    string cavs = "Cleveland Cavaliers";
    string mavs = "Dallas Mavericks";
    string nugs = "Denver Nuggets";
    string lakeshow = "Los Angeles Lakers";
    // The rest of the teams are ommited to save time and test gas, but the example remains relevant. An NBA team (of the 9 above) is successfully selector in a provably random way from a chainlink VRF when the generaterandomnumber function is called.

    //State Variables//

    uint256 public s_RANDOM_NUMBER;
    uint256 public s_LATEST_REQUEST_ID;

    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    //Events//
    // event EnteredRaffle(address indexed player);
    // event WinnerPicked(address indexed player);

    constructor(address vrfCoordinator, bytes32 keyHash, uint64 subscriptionId, uint32 callbackGasLimit)
        VRFConsumerBaseV2(vrfCoordinator)
    {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_keyHash = keyHash;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function generateRandomNumber() external payable {
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_keyHash, i_subscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );

        s_LATEST_REQUEST_ID = requestId;
        pastWinners.push(s_LATEST_REQUEST_ID);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        uint256 RANDOM_NUMBER_BEFORE_MOD = randomWords[0];
        s_RANDOM_NUMBER = RANDOM_NUMBER_BEFORE_MOD % 10;
    }

    // Getter Functions //

    function getRandomNumber() public view returns (uint256) {
        return s_RANDOM_NUMBER;
    }

    function getRequestId() public view returns (uint256) {
        return s_LATEST_REQUEST_ID;
    }

    function getRandomNBATeam() public view returns (string memory) {
        if (s_RANDOM_NUMBER == 0) {
            return hawks;
        }
        if (s_RANDOM_NUMBER == 1) {
            return celtics;
        }
        if (s_RANDOM_NUMBER == 2) {
            return nets;
        }
        if (s_RANDOM_NUMBER == 3) {
            return hornets;
        }
        if (s_RANDOM_NUMBER == 4) {
            return bulls;
        }
        if (s_RANDOM_NUMBER == 5) {
            return cavs;
        }
        if (s_RANDOM_NUMBER == 6) {
            return celtics;
        }
        if (s_RANDOM_NUMBER == 7) {
            return mavs;
        }
        if (s_RANDOM_NUMBER == 8) {
            return nugs;
        }
        if (s_RANDOM_NUMBER == 9) {
            return lakeshow;
        }

        revert somethingwentwrong();
    }

    function getPastWinners() public view returns (uint256[] memory) {
        return pastWinners;
    }
}
