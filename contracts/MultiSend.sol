// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract MultiSend is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {}

    receive() external payable {}

    function multiSendEthers(address payable[] memory recipients, uint256[] memory amounts) public payable onlyOwner {
        require(recipients.length == amounts.length, "Recipients and amounts arrays must have the same length");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(address(this).balance >= amounts[i], "Insufficient contract balance");
            recipients[i].transfer(amounts[i]);
        }
    }

    function multiSendTokens(address[] memory tokens, address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        require(tokens.length == recipients.length && recipients.length == amounts.length, "Arrays must have the same length");

        uint256[] memory totalAmounts = new uint256[](tokens.length);

        // Calculate total amounts for each token
        for (uint256 i = 0; i < tokens.length; i++) {
            totalAmounts[i] += amounts[i];
        }

        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20 erc20Token = IERC20(tokens[i]);
            uint256 balance = erc20Token.balanceOf(msg.sender);
            require(balance >= totalAmounts[i], "Insufficient balance");

            erc20Token.transferFrom(msg.sender, recipients[i], amounts[i]);
        }
    }
}
