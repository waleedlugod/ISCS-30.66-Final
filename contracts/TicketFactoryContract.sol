// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "contracts/TicketContract.sol";

contract TicketFactoryContract{

    TicketContract[] private deployedEvents;

    receive() external  payable { }

    function createEvent(string memory _eventName, uint _eventDate, uint _ticketPrice, uint _maxTickets) public {
        TicketContract newEvent = new TicketContract(msg.sender, _eventName, _eventDate, _ticketPrice, _maxTickets);
        deployedEvents.push(newEvent);
    }

    function getEvents() public view returns (TicketContract[] memory) {
        return deployedEvents;
    }
}