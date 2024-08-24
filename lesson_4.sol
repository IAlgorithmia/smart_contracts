//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract lesson{

    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier checkSource(){
        require(msg.sender == owner, "Owner only access");
        _; //this line means to continue the normal functionality
    }

    modifier validateAddress(address _addr){
        require(_addr != address(0), "Invalid address");
        _;
    }

    function changeOwner(address new_owner) public checkSource validateAddress(new_owner){
        owner = new_owner;
    }

    //access specifiers are compulsary in functions and should notbe there in modifiers
    //see notes
    //the above checks have been abstracted out and implemented powerfully and replicably as modifiers

    bool locked = false; 

    modifier noReentrancy(){
        require(!locked, "No Reentrancy"); //this checks whether locked is true or not, if locked is true then error will be generated
        locked = true; //if the control is coming here then locked was false, execution has now begun, so we are locking the contract
        _; //this will call the next function in the modifier stack
        locked = false; //since we are done with the execution, we unlock the contract 
    }

    uint x = 10; 

    function decrement (uint i) public noReentrancy{
        x -= 1;
        if (i > 1){
            decrement(i - 1);
        }
        //for any i greater than 1, this won't work since the function has 
        //already been called and we are trying to call it again
        //this is a poor example of reentrancy attack though, 
        //chcekout the original reentrancy attack
    }

    //the above is a recursive function, which shows how reentrancy attack can happen and how to prevent it

}