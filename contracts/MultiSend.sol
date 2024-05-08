// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract MultiSend is Ownable {
    using SafeERC20 for IERC20;

    uint total_ether;

    constructor(address initialOwner) Ownable(initialOwner) {}

    receive() external payable {
        total_ether += msg.value;
    }

    function sumEthers(uint[] memory amounts) private pure returns (uint retVal) {
        // the value of message should be exact of total amounts
        uint totalAmnt = 0;

        for (uint i=0; i < amounts.length; i++) {
            totalAmnt += amounts[i];
        }

        return totalAmnt;
    }

    function multiSendEthers(address payable[] memory recipients, uint256[] memory amounts) public payable onlyOwner {
        // first of all, add the value of the transaction to the total_ether
        // of the smart-contract
        total_ether += msg.value;

        require(recipients.length == amounts.length, "Recipients and amounts arrays must have the same length");

        uint totalAmnt = sumEthers(amounts);

        require(total_ether >= totalAmnt, "The value is not sufficient or exceed");

        for (uint256 i = 0; i < recipients.length; i++) {
            // first subtract the transferring amount from the total_value
            // of the smart-contract then send it to the receiver
            total_ether -= amounts[i];

            // send the specified amount to the recipient
            recipients[i].transfer(amounts[i]);
        }
    }

    function multiSendTokens(address[] memory tokens, address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        require(tokens.length == recipients.length && recipients.length == amounts.length, "Arrays must have the same length");

        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20 erc20Token = IERC20(tokens[i]);

            erc20Token.safeTransferFrom(msg.sender, recipients[i], amounts[i]);
        }
    }

    function withdrawEthers(uint amount) public onlyOwner {
        require(amount <= total_ether, "The amount exceeds the total value of the smart-contract");

        total_ether -= amount;

        payable(msg.sender).transfer(amount);
    }
}
