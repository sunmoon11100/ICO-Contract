//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

import './YRCHToken.sol';

/**
* @title Yarchi ICO
* @dev YRCH Tokens ICO contract
*/
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

    /**
     * MODIFIER ONLY ADMIN
     * @dev Modifier that restrict anyone to act
     */
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    /**
     * MODIFIER NOT ADMIN
     * @dev Modifier that restrict admin to act
     */
    modifier notAdmin(){
        require(msg.sender != admin);
        _;
    }

    /**
     * INVEST EVENT
     * @dev Event that acts if someone did investment
     */
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

    /**
     * INVEST FUNCTION
     * @dev Main function ICO - makes ICO owners happy!
     */
    function invest() payable public notAdmin returns(bool){
        require(block.timestamp >= dateStartICO);
        require(state == State.running);
        require(balances[msg.sender] * price < maxInv);
        uint tokensCount;
        tokensCount = msg.value / price;
        balances[msg.sender] += tokensCount;
        balances[founder] -= tokensCount;
        
        deposit.transfer(msg.value);
        emit Invest(msg.sender, msg.value, tokensCount);
        return true;
    }

    /**
     * RECEIVER FUNCTION
     * @dev Default receive function
     */
    receive() payable external{
        invest();
    }
    
    /**
     * REMAINDER INVESTMENT
     * @dev A way to know your remainder investment (max is @param maxInv wei)
     */
    function remainderInvestment() public view returns(uint){
        return maxInv - (balances[msg.sender] * price);
    }

    /**
     * GET CURRENT STATE
     * @dev Get current ICO status
     */
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
    
    /**
     * SET STATE TO HALTED
     * @dev A button to emergency stop ICO
     */
    function halt() public onlyAdmin{
        state = State.halted;
    }

    /**
     * RESUME ICO
     * @dev A button to resume ICO
     */
    function resume() public onlyAdmin{
        state = State.running;
    }
    
    /**
     * SET STATE TO END
     * @dev A cheatcode to end ICO
     */
    function end() public onlyAdmin{
        state = State.ended;
    }

    /**
     * BURN FUNCTION
     * @dev Burn em all! Destroy remainder tokens!
     */
    function burn() public notAdmin returns(bool){
        require(state == State.ended);
        balances[founder] = 0;

        return true;
    }

    /**
     * CHANGE DEPOSIT
     * @dev Change deposit address to @param _newDeposit
     */
    function changeDeposit(address payable _newDeposit) public onlyAdmin returns(bool){
        require(state == State.halted);
        deposit = _newDeposit;
        return deposit == _newDeposit;
    }

    /**
     * TRANSFER TO
     * @dev Transfer @param tokens tokens from owner to @param to
     */

    function transfer(address to, uint tokens) public override returns(bool success){
        require(block.timestamp >= dateUnlock);
        super.transfer(to, tokens);
        return true;
    }

    /**
     * TRANSFER FROM TO
     *  @dev Transfer @param tokens tokens to @param to behalf @param from
     */
    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        require(block.timestamp >= dateUnlock);
        super.transferFrom(from, to, tokens);
        return true;
    }
}