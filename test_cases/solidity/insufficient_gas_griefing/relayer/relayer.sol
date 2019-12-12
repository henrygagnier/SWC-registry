/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/#insufficient-gas-griefing
 * @author: ConsenSys Diligence
 * Modified by Kaden Zipfel
 */

pragma solidity ^0.5.0;

contract Relayer {
    uint transactionId;

    struct Tx {
        bytes data;
        bool executed;
    }

    mapping (uint => Tx) transactions;

    function relay(bytes memory _data) public {
        // replay protection; do not call the same transaction twice
        require(transactions[transactionId].executed == false, 'same transaction twice');
        transactions[transactionId].data = _data;
        transactions[transactionId].executed = true;
        transactionId += 1;

        Target target = new Target();
        address(target).call(abi.encodeWithSignature("execute(bytes)", _data));
    }
}

// Contract called by Relayer
contract Target {
    function execute(bytes memory _data) public {
        // Execute contract code
    }
}