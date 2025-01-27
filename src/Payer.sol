// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Issuer } from "./Issuer.sol";
import { OwnerIsCreator } from "@chainlink/contracts/src/v0.8/shared/access/OwnerIsCreator.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @author  Cohee
 * @title   Payer contract
 * @dev     Please notice that this contract is just in the primary stage and 
            it is not fully tested and developed.
 */

contract Payer is OwnerIsCreator {
    using Strings for uint256;
    error IncorretAmount();
    error withdrawFailed();

    Issuer private issuer;
    uint256 private PaymentAmount;
    uint64 subscriptionId;
    uint32 gasLimit;
    bytes32 donID;

    constructor(address issuerAddress, uint256 _amount, uint64 _subscriptionId, uint32 _gasLimit, bytes32 _donID) {
        issuer = Issuer(issuerAddress);
        PaymentAmount = _amount;
        subscriptionId = _subscriptionId;
        gasLimit = _gasLimit;
        donID = _donID;
    }

    /**
     * @notice  This function is used to accept the payment and use the Issuer contract 
                to complete tokenization.
     * @param   uid  .
     * @return  get the requestId bytes32.
     */
    function PayAndIssue(uint256 uid) external payable returns (bytes32) {
        if (msg.value != PaymentAmount) {
            revert IncorretAmount();
        }
        string[] memory args = new string[](1);
        args[0] = uid.toString();

        bytes32 requestId = issuer.issue(
            msg.sender,
            args, ///用户id
            1, ///发行数量 1
            subscriptionId, ///订阅id
            gasLimit,
            donID
        );
        return requestId;
    }

    function changePaymentAmount(uint256 _amount) external onlyOwner {
        PaymentAmount = _amount;
    }
    function changeSubscriptionId(uint64 _subscriptionId) external onlyOwner {
        subscriptionId = _subscriptionId;
    }
    function changeGasLimit(uint32 _gasLimit) external onlyOwner {
        gasLimit = _gasLimit;
    }
    function changeDonID(bytes32 _donID) external onlyOwner {
        donID = _donID;
    }
    function changeIssuer(address _issuerAddress) external onlyOwner {
        issuer = Issuer(_issuerAddress);
    }
    function changeIssuerOwner(address to) external onlyOwner {
        issuer.transferOwnership(to);
    }

    function acceptIssuerOwner() external onlyOwner {
        issuer.acceptOwnership();
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner().call{ value: address(this).balance }("");
        if (!success) {
            revert withdrawFailed();
        }
    }
}
