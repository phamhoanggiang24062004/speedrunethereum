pragma solidity 0.8.20;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vendor is Ownable {

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    IERC20 public yourToken;

    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = IERC20(tokenAddress);
    }

    // Buy tokens with ETH
    function buyTokens() external payable {
        require(msg.value > 0, "Send ETH to buy tokens");

        uint256 tokensToSend = msg.value * tokensPerEth;
        require(
            yourToken.balanceOf(address(this)) >= tokensToSend,
            "Insufficient tokens in vendor"
        );

        yourToken.transfer(msg.sender, tokensToSend);

        emit BuyTokens(msg.sender, msg.value, tokensToSend);
    }

    // Sell tokens to get ETH back
    function sellTokens(uint256 tokenAmount) external {
        require(tokenAmount > 0, "Specify tokens to sell");

        uint256 ethToSend = tokenAmount / tokensPerEth;
        require(address(this).balance >= ethToSend, "Vendor has insufficient ETH");

        // User must approve Vendor first
        yourToken.transferFrom(msg.sender, address(this), tokenAmount);

        payable(msg.sender).transfer(ethToSend);

        emit SellTokens(msg.sender, tokenAmount, ethToSend);
    }

    // Owner withdraws ETH
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
