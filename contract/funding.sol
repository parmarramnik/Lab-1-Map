// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundCampaign {

    address public beneficiary;
    uint256 public constant TARGET = 5 ether;
    uint256 public constant DEADLINE = 1784073600;

    mapping(address => uint256) public donations;
    address[] public donors;
    bool public finished;
    bool public success;

    constructor(address _beneficiary) {
        beneficiary = _beneficiary;
    }

    function donate() external payable {
        require(block.timestamp < DEADLINE);
        require(msg.value > 0);

        if (donations[msg.sender] == 0) {
            donors.push(msg.sender);
        }

        donations[msg.sender] += msg.value;
    }

    function finish() external {
        require(block.timestamp >= DEADLINE);
        require(!finished);

        finished = true;

        if (address(this).balance >= TARGET) {
            success = true;
            payable(beneficiary).transfer(address(this).balance);
        }
    }

    function refund() external {
        require(finished);
        require(!success);

        uint256 amount = donations[msg.sender];
        require(amount > 0);

        donations[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function donorCount() external view returns (uint256) {
        return donors.length;
    }
}