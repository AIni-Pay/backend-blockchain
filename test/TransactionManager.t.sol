// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/TransactionManager.sol";
import "forge-std/Test.sol";

contract TransactionManagerTest is Test {
    TransactionManager public manager;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        manager = new TransactionManager();
    }

    function testCreateTransaction() public {
        uint256 txId = manager.createTransaction(user2, 1 ether, "ETH");
        (
            address sender,
            address recipient,
            uint256 amount,
            string memory currency,
            , // skip timestamp
            bool executed
        ) = manager.getTransaction(txId);
        assertEq(sender, address(this));
        assertEq(recipient, user2);
        assertEq(amount, 1 ether);
        assertEq(currency, "ETH");
        assertEq(executed, false);
    }

    function testExecuteTransactionETH() public {
        uint256 txId = manager.createTransaction(user2, 1 ether, "ETH");
        vm.prank(address(this));
        manager.executeTransaction{value: 1 ether}(txId);
    (, , , , , bool executed) = manager.getTransaction(txId);
        assertTrue(executed);
    }

    function testGetUserTransactions() public {
        manager.createTransaction(user2, 1 ether, "ETH");
        manager.createTransaction(user1, 2 ether, "ETH");
        uint256[] memory txs = manager.getUserTransactions(address(this));
        assertEq(txs.length, 2);
    }

    function testGetPendingTransactions() public {
        uint256 txId1 = manager.createTransaction(user2, 1 ether, "ETH");
        uint256 txId2 = manager.createTransaction(user1, 2 ether, "ETH");
        manager.executeTransaction{value: 1 ether}(txId1);
        uint256[] memory pending = manager.getPendingTransactions();
        assertEq(pending.length, 1);
        assertEq(pending[0], txId2);
    }
}
