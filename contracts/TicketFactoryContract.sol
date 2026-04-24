// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "contracts/TicketContract.sol";

contract TicketFactoryContract{

    TicketContract[] private deployedEvents;

    address public factoryOwner;

    receive() external  payable { }

    constructor() {
        factoryOwner = msg.sender;
    }

    modifier onlyFactoryOwner(){
        require(msg.sender == factoryOwner, "Not factory owner");
        _;
    }

    function createEvent(string memory _eventName, uint _eventDate, uint _ticketPrice, uint _maxTickets) public {
        TicketContract newEvent = new TicketContract(msg.sender, _eventName, _eventDate, _ticketPrice, _maxTickets);
        deployedEvents.push(newEvent);
    }

    function closeEvent(address _eventContract) public onlyFactoryOwner{
        TicketContract eventContract = TicketContract(_eventContract);
        eventContract.closeEvent();
    }

    function getEvents() public view returns (TicketContract[] memory) {
        return deployedEvents;
    }
}
