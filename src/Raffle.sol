// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Raffle is VRFConsumerBaseV2 {
    //Errors//
    error somethingwentwrong();

    string[] pastWinners;

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

    string s_LATEST_SELECTED_TEAM;
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

    function AssignRandomNBATeam() public returns (string memory) {
        string memory RandomTeam;

        if (s_RANDOM_NUMBER == 0) {
            RandomTeam = hawks;
        } else if (s_RANDOM_NUMBER == 1) {
            RandomTeam = celtics;
        } else if (s_RANDOM_NUMBER == 2) {
            RandomTeam = nets;
        } else if (s_RANDOM_NUMBER == 3) {
            RandomTeam = hornets;
        } else if (s_RANDOM_NUMBER == 4) {
            RandomTeam = bulls;
        } else if (s_RANDOM_NUMBER == 5) {
            RandomTeam = cavs;
        } else if (s_RANDOM_NUMBER == 6) {
            RandomTeam = celtics;
        } else if (s_RANDOM_NUMBER == 7) {
            RandomTeam = mavs;
        } else if (s_RANDOM_NUMBER == 8) {
            RandomTeam = nugs;
        } else if (s_RANDOM_NUMBER == 9) {
            RandomTeam = lakeshow;
        } else {
            revert somethingwentwrong();
        }
        pastWinners.push(RandomTeam);
        s_LATEST_SELECTED_TEAM = RandomTeam;
        return RandomTeam;
    }

    function getPastWinners() public view returns (string[] memory) {
        return pastWinners;
    }

    function getSelectedRandomNBATeam() public view returns (string memory) {
        return s_LATEST_SELECTED_TEAM;
    }
}
