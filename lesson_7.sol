// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleMappingExample {
    // Define a mapping that associates an address with a balance (uint)
    mapping(address => uint) public balances;

    // Function to set a balance for a specific address
    function setBalance(address _address, uint _balance) public {
        balances[_address] = _balance;
    }

    // Function to get the balance of a specific address
    function getBalance(address _address) public view returns (uint) {
        return balances[_address];
    }
}
contract NestedMappingExample {
    // Define a nested mapping where an owner allows a spender to spend a certain amount
    mapping(address => mapping(address => uint)) public allowances;

    // Function to set allowance
    function setAllowance(address _owner, address _spender, uint _amount) public {
        allowances[_owner][_spender] = _amount;
    }

    // Function to get the allowance
    function getAllowance(address _owner, address _spender) public view returns (uint) {
        return allowances[_owner][_spender];
    }
}