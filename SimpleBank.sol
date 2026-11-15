// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract SimpleBank {
    // Mapping to store the Ether balance of each customer's address
    mapping(address => uint) private balances;
    
    // Address of the bank owner/deployer
    address public owner;

    // Events for logging transactions
    event DepositMade(address indexed accountAddress, uint amount);
    event WithdrawalMade(address indexed accountAddress, uint amount);

    // Constructor to set the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // 1. Deposit Money: Send Ether into the bank contract
    function deposit() public payable returns (uint) {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit DepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    // 2. Withdraw Money: Withdraw specified amount of Ether securely using .call()
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(balances[msg.sender] >= withdrawAmount, "Insufficient balance");
        
        balances[msg.sender] -= withdrawAmount;
        
        // Secure modern transfer method
        (bool success, ) = payable(msg.sender).call{value: withdrawAmount}("");
        require(success, "Transfer failed.");

        emit WithdrawalMade(msg.sender, withdrawAmount);
        return balances[msg.sender];
    }

    // 3. Show Balance: Check current Ether balance of the caller
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}
