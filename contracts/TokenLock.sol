//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @custom:security-contact blockchain@sportinvesting.com

contract Timelock {
    uint public immutable end;
    address payable public owner;
    uint public constant duration = 365 days;
    constructor() {
        owner = payable(msg.sender);
        end = block.timestamp + duration;
    }

    function deposit(address token, uint256 amount, uint period) external {
        require(amount >= 0, 'amount is zero');

        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

    receive() external payable {}

    function withdraw(address token, uint amount) external {
        require(msg.sender == owner, 'Only owner');
        require(block.timestamp >= end, 'Too early');
        if (token == address(0)) {
            owner.transfer(amount);
        } else {
            IERC20(token).transfer(owner, amount);
        }
    }

    function transferOwnership(address payable _newOwner) external {
        require(msg.sender == owner, 'Only owner');
        owner = _newOwner;
    }
}
