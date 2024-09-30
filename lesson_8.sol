//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Payable{
    address payable public owner;

    function deposit() public payable {}

    function nonPayable() public {}

    constructor() payable{
        owner = payable(msg.sender);
    }
    function withdraw() public{
        uint amount = address(this).balance;
        (bool success, ) = owner.call{value : amount}("");
        require(success, "Failed send ether");
    }

    function transfer(address payable _to, uint _amount) public{
        uint amountInEther = _amount * 1 ether;
        (bool success, ) = _to.call{value : amountInEther}("");
        require(success, "Failed to transfer ether");
    }
}