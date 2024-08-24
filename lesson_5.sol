//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract X {
    string public textX;
    constructor (string memory _str){
        textX = _str;
    }
}

contract Y {
    string public textY;
    constructor (string memory _str){
        textY = _str;
    }
}

contract Z is X, Y{
    string public name;
    string public textZ;
    constructor (string memory _name, string memory _text) X(_name) Y(_text){
        name = _name;
        textZ = _text;
    }
}