//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13; //the version that we are going to use

contract MyFirstContract{
    // string public hey = "Vaibhav"; //making it public makes it accessible everywhere, otherwise well have to write a special funtion for seeing the value
    // uint256 no = 4;

    string public hey;
    uint256 public no;

    // constructor(string memory _hey, uint _no){
    //     hey = _hey;  /// this is assigning the value of the argument to the variable which is passed in the constructor 
    //     no = _no;  /// this is assigning the value of the argument to the variable which is passed in the constructor
    // }

    function addInfo(string memory _hey, uint _no)  public {//public here means we can access the function anywhere too
        hey = _hey;   /// this is assigning the value of the argument to the variable which is passed in the constructor 
        no = _no;   /// this is assigning the value of the argument to the variable which is passed in the constructor
    }
}
