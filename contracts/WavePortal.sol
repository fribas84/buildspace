// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import '../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '../node_modules/@openzeppelin/contracts/access/Ownable.sol';
import '../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol';


contract WavePortal is Ownable {
    using SafeMath for uint256;
    uint256 totalWaves;

    struct Token {
        bytes32 ticker;
        address tokenAddress;
    }

    mapping(address => uint) public wavesCount;
    mapping(bytes32 => Token) public tokenMapping;
    bytes32[] public tokenList;


    mapping(bytes32 => uint256) public donations;

    uint ethAmount;
    constructor() {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function wave() public {
        totalWaves +=1;
        wavesCount[msg.sender] +=1;
        console.log("%s has waved %d times!", msg.sender, wavesCount[msg.sender]);
        
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function depositEth() payable external{
        ethAmount.add(msg.value);
        console.log("Deposited eth %d!",msg.value);
    }

    function addToken(bytes32 ticker,address tokenAddress) external {
        tokenMapping[ticker] = Token(ticker, tokenAddress);
        tokenList.push(ticker);
       //console.log("Token added => Ticker: %s Address: %s", ticker, tokenAddress);
    }

    modifier tokenExist(bytes32 ticker) {
        require(tokenMapping[ticker].tokenAddress != address(0), 'ERC20 Token does not exist in this contract, please add it.');
        _;
    }

    function deposit(uint amount,  bytes32 ticker) tokenExist(ticker) external {
        IERC20(tokenMapping[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
        donations[ticker] = donations[ticker].add(amount);
    }

    function withdrawEth(uint amount) external onlyOwner {
        require( ethAmount >= amount,'Insuffient balance'); 
        (bool succeed, bytes memory data)  = msg.sender.call{value:amount}("");
        require(succeed, "Failed to withdraw Eth");
    }

    function getEthAmount() external view returns(uint){
        return ethAmount;
    }

    function withdraw(uint amount, bytes32 ticker) tokenExist(ticker) external onlyOwner {
        require(donations[ticker] >= amount,'Insuffient balance'); 
        donations[ticker] = donations[ticker].sub(amount);
        IERC20(tokenMapping[ticker].tokenAddress).transfer(msg.sender, amount);
    }

}

