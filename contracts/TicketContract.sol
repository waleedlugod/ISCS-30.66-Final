// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TicketContract {

    address parentContract;
    address public organizer;

    mapping(uint => address) public ticketOwner;

    string public eventName;
    uint public eventDate;
    uint public ticketPrice;

    enum Status { OPEN, SOLD_OUT }
    Status public status;


    modifier onlyTicketOwner(uint _ticketID){
        require(ticketOwner[_ticketID] == msg.sender, "You are not the ticket owner!");
        _;
    }

    constructor (address _organizer, string memory _eventName, uint _eventDate, uint _ticketPrice){
        parentContract = msg.sender;
        organizer = _organizer;
        eventName = _eventName;
        eventDate = _eventDate;
        ticketPrice = _ticketPrice;
        status = Status.OPEN;
    }

}


