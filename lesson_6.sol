//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Mapping{
    mapping(address => uint) roll_no;
    
    function setRollNo(address _addr, uint _roll) public {
        roll_no[_addr] = _roll;
    }

    function getRollNo(address _addr) public view returns(uint){
        return roll_no[_addr]; 
    }

    function deleteRollNo(address _addr) public {
        delete roll_no[_addr]; 
    }
}

contract MultiMapping{
    mapping(address => mapping(uint => bool)) passOrNot;
    
    function setPass(address _addr, uint _roll, bool _pass) public {
        passOrNot[_addr][_roll] = _pass;
    }

    function getPass(address _addr, uint _roll) public view returns(bool){
        return passOrNot[_addr][_roll]; 
    }

    function deletePassData(address _addr, uint _roll) public {
        delete passOrNot[_addr][_roll]; 
    }
}