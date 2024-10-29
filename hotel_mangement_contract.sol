//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Hotel{

    address payable tenant;
    address payable landlord;

    uint public no_of_rooms = 0;
    uint public no_of_aggrement = 0;
    uint public no_of_rent = 0;

    struct Room{
        uint room_id;
        uint agreement_id;
        string room_name;
        string room_address;
        uint rent_per_month;
        uint security_deposit;
        uint timestamp;
        bool vacant;
        address payable landlord;
        address payable current_tenant;
    }

    mapping(uint => Room) public room_by_no;

    struct RoomAgreement{
        uint room_id;
        uint agreement_id;
        string room_name;
        string room_address;
        uint rent_per_month;
        uint security_deposit;
        uint lock_in_period;
        uint timestamp;
        address payable tenant_address;
        address payable landlord_address;
    }

    mapping(uint => RoomAgreement) public room_agreement_by_no;

    struct Rent{
        uint rent_no;
        uint room_id;
        uint agreement_id;
        string room_name;
        string room_address;
        uint rent_per_month;
        uint timestamp;
        address payable tenant_address;
        address payable landlord_address;
    }

    mapping (uint => Rent) public rent_by_no;

    modifier only_landlord(uint _index){
        require (msg.sender == room_by_no[_index].landlord, "Only landlord can access this");
        _;
    }

    modifier not_landlord(uint _index){
        require (msg.sender != room_by_no[_index].landlord, "Only tenants can access this");
        _;
    }

    modifier only_while_vacant(uint _index){
        require (room_by_no[_index].vacant == true, "Room is not vacant");
        _;
    }

    modifier enough_rent(uint _index){
        require (msg.value >= room_by_no[_index].rent_per_month, "Not enough ether in your wallet");
        _;
    }

    modifier enough_agreement_fee(uint _index){
        require (msg.value >= room_by_no[_index].rent_per_month + room_by_no[_index].security_deposit);
        _;
    }

    modifier same_tenant(uint _index){
        require (msg.sender == room_by_no[_index].current_tenant, "You are not the tenant of this room");
        _;
    }

    modifier agreement_time_left(uint _index){
        uint time = room_agreement_by_no[room_by_no[_index].agreement_id].timestamp + room_agreement_by_no[room_by_no[_index].agreement_id].lock_in_period;
        require (block.timestamp <= time, "Agreement has expired");
        _; 
    }
    
    modifier agreement_time_up(uint _index){
        uint time = room_agreement_by_no[room_by_no[_index].agreement_id].timestamp + room_agreement_by_no[room_by_no[_index].agreement_id].lock_in_period;
        require (block.timestamp > time, "Agreement has not yet expired");
        _; 
    } 

    modifier rent_time_up(uint _index){
        uint time = room_agreement_by_no[room_by_no[_index].agreement_id].timestamp + room_agreement_by_no[room_by_no[_index].agreement_id].lock_in_period;
        require (block.timestamp >= time, "Timeleft to pay the rent");
        _; 
    }   

    function add_room(string memory _roomname, string memory _roomaddress, uint _rentcost, uint _security) public {
        require (msg.sender != address(0));
        no_of_rooms++;
        room_by_no[no_of_rooms] = Room(no_of_rooms, 0, _roomname, _roomaddress, _rentcost, _security, 0, true, payable(msg.sender), payable(address(0)));
    }   

    function signAgreement(uint _index, uint _duration) public payable not_landlord(_index) enough_agreement_fee(_index) only_while_vacant(_index){
        require(msg.sender != address(0));
        address payable _landlord = room_by_no[_index].landlord;
        uint total_fee = room_by_no[_index].rent_per_month + room_by_no[_index].security_deposit;
        (bool sent, ) = _landlord.call{value : total_fee}("");
        require(sent, "Failed to sign agreement");
        no_of_aggrement++;
        room_by_no[_index].current_tenant = payable(msg.sender);
        room_by_no[_index].timestamp = block.timestamp; //wrong this is
        room_by_no[_index].vacant = false;
        room_by_no[_index].agreement_id = no_of_aggrement;
        room_agreement_by_no[no_of_aggrement] = RoomAgreement(_index, no_of_aggrement, room_by_no[_index].room_name, room_by_no[_index].room_address, room_by_no[_index].rent_per_month, room_by_no[_index].security_deposit, _duration, block.timestamp, payable(msg.sender), _landlord);
        no_of_rent++;
        rent_by_no[no_of_rent] = Rent(no_of_rent, _index, no_of_aggrement, room_by_no[_index].room_name, room_by_no[_index].room_address, room_by_no[_index].rent_per_month, block.timestamp, payable(msg.sender), _landlord);
    }

    function payRent(uint _index) public payable same_tenant(_index) rent_time_up(_index) enough_rent(_index) {
        require(msg.sender != address(0));
        address payable _landlord = room_by_no[_index].landlord;
        uint _rent = room_by_no[_index].rent_per_month;
        (bool res, ) = _landlord.call{value : _rent}("");
        require(res, "Rent payment failed");
        room_by_no[_index].current_tenant = payable(msg.sender);
        room_by_no[_index].vacant = false;
        no_of_rent++;
        rent_by_no[no_of_rent] = Rent(no_of_rent, _index, no_of_aggrement, room_by_no[_index].room_name, room_by_no[_index].room_address, room_by_no[_index].rent_per_month, block.timestamp, payable(msg.sender), _landlord);
    }

    function agreementCompleted(uint _index) public payable only_landlord(_index) agreement_time_up(_index) {
        require(msg.sender != address(0));
        require(room_by_no[_index].vacant == false, "Room is already vacant!");
        room_by_no[_index].vacant = true;
        address payable _tenant = room_by_no[_index].current_tenant;
        uint security_deposit = room_by_no[_index].security_deposit;
        (bool res, ) = _tenant.call{value : security_deposit}("");
        require(res, "Agreement Completion Failed!");
    }

    function agreement_terminated(uint _index) public only_landlord(_index) agreement_time_left(_index){
        require(msg.sender != address(0));
        room_by_no[_index].vacant = true;
    }

}