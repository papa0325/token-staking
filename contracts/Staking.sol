// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./Token.sol";

contract Staking {
    Token public token;

    // declaring total staked
    uint256 public totalStaked;

    // users staking balance
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public timeStamp;

    function deposit(uint256 _amount) public {
        // must be more than 0
        require(_amount > 0, "amount can't be 0");
        // User adding test tokens
        require(
            token.allowance(msg.sender, address(this)) >= _amount,
            "Not approved for transfrom"
        );
        token.transferFrom(msg.sender, address(this), _amount);

        totalStaked = totalStaked + _amount;

        // updating staking balance for user by mapping
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
        timeStamp[msg.sender] = block.timestamp;
    }

    function withdraw() public returns (uint256) {
        // get staking balance for user
        uint256 balance = stakingBalance[msg.sender];

        // amount should be more than 0
        require(balance > 0, "amount has to be more than 0");

        uint256 reward = balance * (block.timestamp - timeStamp[msg.sender]);

        // transfer staked tokens back to user
        token.transfer(msg.sender, balance + reward);
        totalStaked = totalStaked - balance;

        // reseting users staking balance
        stakingBalance[msg.sender] == 0;

        return balance + reward;
    }
}
