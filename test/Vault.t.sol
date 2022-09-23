// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/Attacker.sol";

contract VaultTest is Test {
    Vault public vault;
    function setUp() public {
        vault = new Vault{value: 1 ether}();
    }

    function testSolve() public {

        startHoax(0x673C3ff0835cE550fb13DCFeC75795324F85ef00, 4 ether);

        vault.deposit{value: 2 ether}(2 ether, 0x673C3ff0835cE550fb13DCFeC75795324F85ef00);
        Attacker attacker = new Attacker(vault); 

        vault.approve(address(attacker), 2 ether);

        attacker.attack{value: 1 ether}();

        vault.captureTheFlag(0x673C3ff0835cE550fb13DCFeC75795324F85ef00);       

        assertTrue(vault.flagHolder() == 0x673C3ff0835cE550fb13DCFeC75795324F85ef00);
    }

    receive() external payable {

    }

}
