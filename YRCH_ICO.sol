//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

import './YRCHToken.sol';

contract YRCH_ICO is YRCHToken{
    address admin;
    address payable deposit;
    uint public price;
    uint public hardCap;
    uint public raisedAmount;
    uint public dateStartICO;
    uint public dateEndICO;
    uint public dateUnlock;
    uint public maxInv;
    uint public minInv;
    enum State{beforeStart, running, ended, halted}
    State public state;

    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    modifier notAdmin(){
        require(msg.sender != admin);
        _;
    }

    event

    constructor(address _admin, address payable _deposit){

    }

    


}