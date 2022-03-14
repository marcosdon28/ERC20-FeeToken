// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ownable{    
    address private _owner;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(){
        _owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(isOwner(),
        "This function only can be called by an owner !");
        _;
    }


    function owner() public view returns(address) {
        return _owner;
    }
    
    
    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        address oldOwner = _owner;
        _owner = _newOwner;
        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    function renounceOwnership() external onlyOwner {
        transferOwnership(address(0));
    }

}
