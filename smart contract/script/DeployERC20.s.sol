// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {ERC20} from "../src/ERC20.sol";

contract DeployFundMe is Script{
    function run() external returns(ERC20) {
        vm.startBroadcast();

        ERC20 erc20 = new ERC20();
        vm.stopBroadcast();
        return erc20;
    }
}