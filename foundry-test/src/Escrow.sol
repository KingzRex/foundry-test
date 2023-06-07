pragma solidity ^0.8.0;

contract Escrow {
    address payable public buyer;
    address payable public seller;
    address public arbiter;
    uint public amount;
    bool public isFunded;
    bool public isReleased;
    bool public isRefunded;
    
    constructor(address payable _seller, address _arbiter) {
        buyer = payable(msg.sender);
        seller = _seller;
        arbiter = _arbiter;
        amount = 0;
        isFunded = false;
        isReleased = false;
        isRefunded = false;
    }
    
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function.");
        _;
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can call this function.");
        _;
    }
    
    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only the arbiter can call this function.");
        _;
    }
    
    modifier inState(bool _condition) {
        require(_condition, "Invalid contract state.");
        _;
    }
    
    function fund() public payable onlyBuyer inState(!isFunded) {
        require(msg.value > 0, "Funded amount must be greater than zero.");
        amount += msg.value;
        isFunded = true;
    }
    
    function release() public onlySeller inState(isFunded) {
        seller.transfer(amount);
        isReleased = true;
    }
    
    function refund() public onlyBuyer inState(isFunded) {
        buyer.transfer(amount);
        isRefunded = true;
    }
    
    function arbitrate() public onlyArbiter inState(isFunded) {
        uint dividedAmount = amount / 2;
        seller.transfer(dividedAmount);
        buyer.transfer(dividedAmount);
        isReleased = true;
    }
}
