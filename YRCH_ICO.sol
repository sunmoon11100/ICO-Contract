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

    event Invest(address _investor, uint _value, uint _tokens);

    constructor(address _admin, address payable _deposit){
        admin = _admin;
        deposit = _deposit;
        price = 0.0001 ether;
        hardCap = 1000 ether;
        raisedAmount = 0;
        dateStartICO = block.timestamp;
        dateEndICO = dateStartICO + 1 days;
        dateUnlock = dateEndICO + 180 days;
        maxInv = 10 ether;
        minInv = 0.001 ether;
        state = State.beforeStart;
    }

    function invest() payable public notAdmin returns(address){

    }

    receive() payable external{
        invest();
    }

    function getStatus() public view returns(string memory){
        string memory result;
        if(state == State.beforeStart){
            result = "Not Started Yet";
        }else if(state == State.running){
            result = "Running";
        }else if(state == State.ended){
            result = "Ended";
        }else
            result = "halted";

        return result;
    }

    function burn() public notAdmin returns(bool){

    }

    



    


}