//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @custom:security-contact blockchain@sportinvesting.com

contract TokenLock {
    uint256 public immutable end;
    address payable public owner;
    uint256 public immutable duration;
    
    constructor(uint256 _duration) {
        owner = payable(msg.sender);
        duration = _duration;
        end = block.timestamp + _duration;
    }

    function deposit(address token, uint256 amount) external {
        require(amount > 0, 'Amount is zero');

        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

    receive() external payable {}

    function withdraw(address token, uint256 amount) external {
        require(msg.sender == owner, 'Only owner');
        require(block.timestamp >= end, 'Too early');

        if (token == address(0)) {
            owner.transfer(amount);
        } else {
            IERC20(token).transfer(owner, amount);
        }
    }

    function transferOwnership(address payable newOwner) external {
        require(msg.sender == owner, 'Only owner');

        owner = newOwner;
    }
}
