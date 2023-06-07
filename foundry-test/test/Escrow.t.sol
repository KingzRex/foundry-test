// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow private escrow;
    address private buyer;
    address private seller;
    address private arbiter;

    function beforeEach()  public {
        // super.beforeEach();

        buyer = 0xC010bEAb5C3BE2d4811F35609D5B29441aCeAB23;
        seller = 0x675951c3ECe300707A075d2f2714783284897E0A;
        arbiter = 0xdAe00969D9B289F9A305b3572B23aF151a0C2aC8;

        escrow = new Escrow(payable(seller), arbiter);
    }
   
     function testInitialContractState() public {
        assertEq(escrow.buyer(), buyer, "Incorrect buyer address");
        assertEq(escrow.seller(), seller, "Incorrect seller address");
        assertEq(escrow.arbiter(), arbiter, "Incorrect arbiter address");
        assertEq(escrow.amount(), 0, "Incorrect initial amount");
        assertFalse(escrow.isFunded(), "Incorrect initial isFunded state");
        assertFalse(escrow.isReleased(), "Incorrect initial isReleased state");
        assertFalse(escrow.isRefunded(), "Incorrect initial isRefunded state");
    }

    function testFunding() public {
        escrow.fund{value: 100}();
        assertEq(escrow.amount(), 100, "Incorrect funded amount");
        assertTrue(escrow.isFunded(), "isFunded state should be true");
    }

    function testRelease() public {
        escrow.fund{value: 100}();
        escrow.release();
        assertTrue(escrow.isReleased(), "isReleased state should be true");
    }

    function testRefund() public {
        escrow.fund{value: 100}();
        escrow.refund();
        assertTrue(escrow.isRefunded(), "isRefunded state should be true");
    }

    function testArbitrate() public {
        escrow.fund{value: 100}();
        escrow.arbitrate();
        assertTrue(escrow.isReleased(), "isReleased state should be true");
    }
}