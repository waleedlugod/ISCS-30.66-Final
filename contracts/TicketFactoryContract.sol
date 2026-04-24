// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "contracts/TicketContract.sol";

contract TicketFactoryContract{

    address factoryOwner;

    constructor() {
        factoryOwner = msg.sender; // The person who deployed the factory
    }

    TicketContract[] private deployedEvents;

    receive() external  payable { }

    function createEvent(string memory _eventName, uint _eventDate, uint _ticketPrice, uint _maxTickets) public {
        TicketContract newEvent = new TicketContract(msg.sender, _eventName, _eventDate, _ticketPrice, _maxTickets);
        deployedEvents.push(newEvent);
    }

    function getEvents() public view returns (TicketContract[] memory) {
        return deployedEvents;
    }
    
    // Allow the factory owner to withdraw funds from factory contract
    function withdrawFactoryFunds() public {
        require(msg.sender == factoryOwner, "Only the factory owner can do this");
        
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw");

        // This is the modern standard syntax
        (bool success, ) = payable(factoryOwner).call{value: amount}("");
        require(success, "Transfer failed");
    }
}