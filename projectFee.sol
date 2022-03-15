// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./Ownable.sol";

contract ProjectFee is IERC20, Ownable{
    string public constant name = "ProjectFeeToken";
    string public constant symbol = "PFEE";
    uint public constant decimals = 0;
    
    mapping(address=>uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    mapping(address => bool) isExcluded;
    mapping(address => uint) partOfPool;
    uint256 totalSupply_;
    address marketingAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    uint ownerFeeReward_ = 5;
    uint marketingFeeReward_ = 5;
    uint holdersFeeReward_ = 5;
    uint burnedFeePercent_ = 3;
    uint nativeTokenFee_ = 2;
    uint burnedTokens;
    
    uint totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;


    constructor(uint _initialSupply /*uint _OwnerFeeReward, uint _marketingFeeReward, uint _holdersFeeReward, uint _burnedFeePercent, uint _nativeTokenFee, address _marketingAddress*/){
        totalSupply_ = _initialSupply;
        balances[msg.sender]=totalSupply_;
        //ownerFeeReward_ = _OwnerFeeReward;
        //marketingFeeReward_ = _marketingFeeReward;
        //holdersFeeReward_ = _holdersFeeReward;
        //burnedFeePercent_ = _burnedFeePercent;
        //nativeTokenFee_ = _nativeTokenFee;
        //totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;
        //marketingAddress = _marketingAddress
    }

    modifier correctFee(uint _fee){
        require(_fee <=100);
        _;

    }
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns (uint256){
        return allowed[owner][delegate];
    }

    function transfer(address recipient, uint256 numTokens) public override returns (bool){
        determinePartOfPool();
        require(numTokens <=balances[msg.sender]); 
        if(isExcluded[msg.sender] !=false){
            balances[msg.sender]=balances[msg.sender] - (numTokens);
            balances[recipient]=balances[recipient] + (numTokens);
            emit Transfer(msg.sender, recipient, numTokens);
            return true;
        }
        else{
            balances[msg.sender]=balances[msg.sender] - (numTokens);

            //calculating part for owner
            uint ownerReward = (ownerFeeReward_ * numTokens ) / 100;
            //calculating part for marketing address
            uint marketingReward = (marketingFeeReward_ * numTokens) / 100;
            //calculating part to burn
            uint burnedAmount = (burnedFeePercent_ * numTokens) / 100 ;
            
            burnedTokens += burnedAmount;
            totalSupply_ -= burnedAmount;
            balances[owner()] += ownerReward;
            balances[marketingAddress] += marketingReward;

            uint amountToRecipient = numTokens - (ownerReward + burnedTokens);
            balances[recipient] += amountToRecipient;
            emit Transfer(msg.sender, recipient, numTokens);
            return true;
        }
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool){
        allowed[msg.sender][delegate]=numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    function increaseTotalSupply(uint newTokensAmount) public onlyOwner() {
        totalSupply_+=newTokensAmount;
        balances[msg.sender]+= newTokensAmount;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public onlyOwner() override returns (bool){
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner] - (numTokens);
        allowed[owner][msg.sender]=allowed[owner][msg.sender] - (numTokens);
        balances[buyer]=balances[buyer] + (numTokens);
        emit Transfer (owner, buyer, numTokens);
        return true;
    }

    function totalFees()public view returns(uint){
        return totalFee_;
    }

    function changeOwnerRewardFee(uint _fee)public onlyOwner correctFee(_fee){
        ownerFeeReward_ = _fee;
        totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;
    }

    function changeMarketingRewardFee(uint _fee)public onlyOwner correctFee(_fee){
        marketingFeeReward_ = _fee;
        totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;
    }

    function changeHoldersFeeReward(uint _fee)public onlyOwner correctFee(_fee){
        holdersFeeReward_ = _fee;
        totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;

    }

    function changeBurnedFeePercent(uint _fee)public onlyOwner correctFee(_fee){
        burnedFeePercent_ = _fee;
        totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;
        
    }

    function changeNativeTokenFee(uint _fee)public onlyOwner correctFee(_fee){
        nativeTokenFee_ = _fee;
        totalFee_ = ownerFeeReward_ + marketingFeeReward_ + holdersFeeReward_ + burnedFeePercent_ + nativeTokenFee_ ;
        
    }

    function changeMarketingAddress(address _new)public onlyOwner {
        marketingAddress = _new;
    }

    function viewMarketingAddress()public view returns(address){
        return marketingAddress;

    }
    function viewBurnedTokens()public view returns(uint){
        return burnedTokens;

    }
    function excludeAddress(address _newExcluded)public onlyOwner{
        isExcluded[_newExcluded] = true;
    }

    function isAddressExcluded() public view returns(bool){
        return isExcluded[msg.sender];
    }

    function determinePartOfPool()public onlyOwner{
        uint balance = balances[msg.sender];
        uint part = (balance * 100 ) / totalSupply_;
        partOfPool[msg.sender] = part;

    }
    function viewPartOfPool()public view returns(uint){
        return partOfPool[msg.sender];
    }
}