//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract EventTicket{
    uint numberOfTickets;
    uint ticketPrice;
    uint totalAmount;
    uint startsAt;
    uint endsAt;
    uint timeRange;
    string public message = "Buy your FIRST EVER event ticket";

    constructor(uint _ticketPrice){
        ticketPrice = _ticketPrice;
        startsAt = block.timestamp;
        endsAt = startsAt + 7 days; 
        timeRange = (endsAt - startsAt) / 24 / 60 / 60; //to convert it into days
    }

    function buyTicket(uint _value) public returns(uint ticketId){ //we write 
        numberOfTickets++;
        totalAmount += _value;
        ticketId = numberOfTickets;
        //generally I only write the datatype uint, string etc... in the above return statement
        // return ticketId; when I'm writing ticketId name above
        //I need not write another return since the function will automatically return that value
    }

    function getAmount() public view returns (uint){
        return totalAmount;
        //since ive only written the type of variable that Im going to pass Ill need to 
        //return the variable itself
    }
}