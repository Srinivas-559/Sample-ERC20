//SPDX-License-Identifier:MIT 
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;



    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 private constant STARTING_USER_BALANCE = 100 ether ;



    function setUp() public {

        deployer = new DeployOurToken();
        ourToken =  deployer.run();


        vm.prank(msg.sender);
        ourToken.transfer(bob,STARTING_USER_BALANCE);



    }
    function testBobBalance() public {
        assertEq(STARTING_USER_BALANCE,ourToken.balanceOf(bob));
    }
    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(bob);
        ourToken.approve(alice,initialAllowance);


        vm.prank(alice);
        ourToken.transferFrom(bob,alice,transferAmount);

        assertEq(ourToken.balanceOf(bob),STARTING_USER_BALANCE-transferAmount);


    }

    function testTransfer() public {
        uint256 transferAmount = 500;
       uint256 starting_bob_balance=ourToken.balanceOf(bob);
       uint256 starting_alice_balance = ourToken.balanceOf(alice);
        vm.prank(bob);
        ourToken.transfer(alice,transferAmount);
        assertEq(ourToken.balanceOf(bob),starting_bob_balance-transferAmount);
        assertEq(ourToken.balanceOf(alice),starting_alice_balance+transferAmount);
    }
    function testBalanceAfterTransfer( ) public {
        uint256 amount = 100;
        address receiver = address(0x1);
        uint256 intialBalance = ourToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        ourToken.transfer(receiver,amount);
        assertEq(ourToken.balanceOf(msg.sender),intialBalance-amount);
    }
    function testTransferFrom() public {
        uint256 amount = 100;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        ourToken.approve(msg.sender,amount);
        vm.prank(msg.sender);
        ourToken.transferFrom(msg.sender,receiver,amount);
        assertEq(ourToken.balanceOf(receiver),amount);


    }

}
