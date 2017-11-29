pragma solidity ^0.4.4;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';

// Define a contract
contract EtherealizeToken is StandardToken {
    // Set a name for the token
    string public name = "Etherealize";
    // Set a symbol for the token
    string public symbol = "ETR";
    // Specify to what number of decimals the token be divisible to
    uint public decimals = 10;
    // Specify the total token supply upon contract deployment
    uint public INITIAL_SUPPLY = 50000000;
    // Define a constructor
    // Constructor runs once on contract creation transaction
    function EtherealizeToken() {
        // Make totalSupply equal to the INITIAL_SUPPLY
        totalSupply = INITIAL_SUPPLY;
        // Assign the entire initial supply to the individual that interacts with the contract. Eg. msg.sender.
        balances[msg.sender] = INITIAL_SUPPLY;
    }

}