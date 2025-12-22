// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ExampleExternalContract.sol";

contract Staker {

    ExampleExternalContract public exampleExternalContract;

    mapping(address => uint256) public balances;

    uint256 public constant threshold = 1 ether;
    uint256 public deadline;
    bool public openForWithdraw;

    event Stake(address indexed staker, uint256 amount);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
        deadline = block.timestamp + 120 seconds;
    }

    modifier onlyBeforeDeadline() {
        require(block.timestamp < deadline, "Staking period over");
        _;
    }

    modifier onlyAfterDeadline() {
        require(block.timestamp >= deadline, "Too early");
        _;
    }

    function stake() public payable onlyBeforeDeadline {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function timeLeft() public view returns(uint256) {
        if (block.timestamp >= deadline) return 0;
        return deadline - block.timestamp;
    }

    function execute() public onlyAfterDeadline {
        if (openForWithdraw) return;

        if(address(this).balance >= threshold) {
            uint256 amount = address(this).balance;
            exampleExternalContract.complete{ value: amount }();
        } else {
            openForWithdraw = true;
        }
    }

    function withdraw() public onlyAfterDeadline {
        require(openForWithdraw, "Not open for withdraw");
        uint256 bal = balances[msg.sender];
        require(bal > 0, "Nothing to withdraw");

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
    }

    receive() external payable {
        stake();
    }
}
