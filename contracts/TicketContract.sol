// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TicketContract {

    address parentContract;
    address public organizer;
    uint public transferFee;

    struct Ticket {
        address owner;
        uint purchaseTimestamp;
        uint lastTransferTimestamp;
    }

    mapping(uint => Ticket) public ticketOwner;

    string public eventName;
    uint public eventDate;
    uint public ticketPrice;

    enum Status { OPEN, SOLD_OUT }
    Status public status;

    uint private ticketIDCounter;


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
        ticketIDCounter = 0;
        transferFee = 100 wei;
    }

    function buyTicket() public payable returns (uint) {
        require(msg.value == ticketPrice, "Not correct payment amount!");
        uint ticketID = createTicketID();
        ticketOwner[ticketID] = msg.sender;
        return ticketID;
    }

    function transferTicket(uint _ticketID, address _to) public payable onlyTicketOwner(_ticketID) {
        require(msg.value == transferFee, "Not correct transfer fee payment!");
        ticketOwner[_ticketID] = _to;
    }

    function createTicketID() private returns (uint) {
        return ticketIDCounter++;
    }
}


