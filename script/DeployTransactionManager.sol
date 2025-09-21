// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/TransactionManager.sol";
import "forge-std/Script.sol";

contract DeployTransactionManagerScript is Script {
    function run() external {
        vm.startBroadcast();
        
        TransactionManager transactionManager = new TransactionManager();
        
        vm.stopBroadcast();
        
        console.log("TransactionManager deployed at:", address(transactionManager));
    }
}
