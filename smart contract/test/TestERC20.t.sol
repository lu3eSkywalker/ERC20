// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Test, console} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 e;

    address contractOwner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint ethToWei = 10 ** 18;

    function setUp() public {
        e = new ERC20();
    }

    function test_Mint() public {
        e.initialize("Dogecoin", "DOGE", 10);
        assertEq(e.balanceOf(address(this)), 10 * ethToWei, "OK");
    }

    function test_Transfer() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        e.initialize("Dogecoin", "DOGE", 1000);
        e.transfer(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 1000 * ethToWei);
        assertEq(e.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8), 1000 * ethToWei, "OK");
        vm.stopPrank();
    }

    function test_burnTokens() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        e.initialize("Dogecoin", "DOGE", 1000);
        e.burn(1000 * ethToWei);
        assertEq(e.balanceOf(contractOwner), 0, "OK");
    }

    function test_Approve() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        e.initialize("Dogecoin", "DOGE", 100);
        e.approve(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 100 * ethToWei);
        vm.stopPrank();

        // Transferring Token using transferFrom using the approved Account
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        e.transferFrom(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 50 * ethToWei);
        assertEq(e.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8), 50 * ethToWei, "OK");

        // Burning the tokens using burnFrom using the approved token Account
        e.burnFrom(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 50 * ethToWei);
        assertEq(e.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 0, "OK");
    }


    // Negative Tests

    function testFail_tokenMint() public {
        e.initialize("Dogecoin", "DOGE", 10);
        assertEq(e.balanceOf(address(this)), 100 ** ethToWei, "OK");
    }

    function testFail_TokenTransfer() public {
        e.initialize("Dogecoin", "DOGE", 10);
        e.transfer(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100 * ethToWei);
    }

    function testFail_TokenBurn() public {
        e.initialize("Dogecoin", "DOGE", 10);
        e.burn(100 * ethToWei);
    }

    function testFail_ApproveAllowance() public {
        e.initialize("Dogecoin", "DOGE", 10);
        e.approve(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100 * ethToWei);

        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        e.transferFrom(address(this), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100 * ethToWei);
        e.burnFrom(address(this), 100 * ethToWei);
    }
}