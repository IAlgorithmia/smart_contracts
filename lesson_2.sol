//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract sample{

    uint256 public currentNFTs = 0;
    //can only represent 0 or positive numbers

    function viewNFTs() public view returns (uint256){
        return currentNFTs;
    }

    function incrementNFT() public {
        currentNFTs += 1;
    }

    function decrementNFT() public {
        currentNFTs -= 1;
    }

}