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
    uint public maxTickets;
    uint public soldTickets;

    uint private ticketIDCounter;

    enum Status { OPEN, SOLD_OUT, CLOSED }
    Status public status;

    modifier onlyTicketOwner(uint _ticketID){
        require(ticketOwner[_ticketID].owner == msg.sender, "You are not the ticket owner!");
        _;
    }

    modifier onlyOrganizer() {
        require(msg.sender == organizer, "You are not the organizer!");
        _;
    }   

    constructor (address _organizer, string memory _eventName, uint _eventDate, uint _ticketPrice, uint _maxTickets){
        parentContract = msg.sender;
        organizer = _organizer;
        eventName = _eventName;
        eventDate = _eventDate;
        ticketPrice = _ticketPrice;
        maxTickets = _maxTickets;

        status = Status.OPEN;
        ticketIDCounter = 0;
        soldTickets = 0;
        transferFee = 100 wei;
    }

    function buyTicket() public payable returns (uint) {
        require(status == Status.OPEN, "Ticket sales are closed!");
        require(msg.value == ticketPrice, "Not correct payment amount!");
        require(soldTickets < maxTickets, "All tickets have been sold!");

        uint ticketID = createTicketID();
        ticketOwner[ticketID] = Ticket({
            owner: msg.sender,
            purchaseTimestamp: block.timestamp,
            lastTransferTimestamp: block.timestamp
        });

        soldTickets++;
        if (soldTickets == maxTickets){
            status = Status.SOLD_OUT;
        }
        return ticketID;
    }

    function transferTicket(uint _ticketID, address _to) public payable onlyTicketOwner(_ticketID) {
        require(status != Status.CLOSED, "Event is closed");
        require(msg.value == transferFee, "Not correct transfer fee payment!");
        ticketOwner[_ticketID].owner = _to;
        ticketOwner[_ticketID].lastTransferTimestamp = block.timestamp;
    }

    function createTicketID() private returns (uint) {
        return ticketIDCounter++;
    }

    function closeEvent() public onlyOrganizer {
        require(status == Status.OPEN, "Event already closed.");
        status = Status.CLOSED;
    }

}


