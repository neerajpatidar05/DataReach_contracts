// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// contract DataReachToken {
//     string public name = "DATAREACH AI";
//     string public symbol = "DATAI";
//     uint256 public totalSupply = 1200000000 * 10 ** 18; 

//     mapping(address => uint256) public balanceOf;
//     mapping(address => mapping(address => uint256)) public allowance;

//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event Approval(address indexed owner, address indexed spender, uint256 value);

//     address public miraiEcosystem = 0xfA4CE42aC4717C5bA525035c6c547df34Ac63e1b; 
//     address public founderTeam = 0xfA4CE42aC4717C5bA525035c6c547df34Ac63e1b; 
//     address public community = 0xfA4CE42aC4717C5bA525035c6c547df34Ac63e1b; 
//     address public marketing = 0xfA4CE42aC4717C5bA525035c6c547df34Ac63e1b; 
//     address public liquidityListing =0xfA4CE42aC4717C5bA525035c6c547df34Ac63e1b;
//     address public seedRound =0xfA4CE42aC4717C5bA525035c6c547df34Ac63e1b;

//     constructor() {
//         uint256 miraiAllocation = (totalSupply * 65) / 100;
//         uint256 founderAllocation = (totalSupply * 114) / 1000;
//         uint256 communityAllocation = (totalSupply * 55) / 1000;
//         uint256 marketingAllocation = (totalSupply * 54) / 1000;
//         uint256 liquidityAllocation = (totalSupply * 5) / 100;
//         uint256 seedRoundAllocation = (totalSupply * 77) / 1000;

//         balanceOf[miraiEcosystem] = miraiAllocation;
//         balanceOf[founderTeam] = founderAllocation;
//         balanceOf[community] = communityAllocation;
//         balanceOf[marketing] = marketingAllocation;
//         balanceOf[liquidityListing] = liquidityAllocation;
//         balanceOf[seedRound] = seedRoundAllocation;

//         emit Transfer(address(0), miraiEcosystem, miraiAllocation);
//         emit Transfer(address(0), founderTeam, founderAllocation);
//         emit Transfer(address(0), community, communityAllocation);
//         emit Transfer(address(0), marketing, marketingAllocation);
//         emit Transfer(address(0), liquidityListing, liquidityAllocation);
//         emit Transfer(address(0), seedRound, seedRoundAllocation);
//     }

//     function transfer(address to, uint256 value) public returns (bool) {
//         require(balanceOf[msg.sender] >= value, "Insufficient balance");
//         balanceOf[msg.sender] -= value;
//         balanceOf[to] += value;
//         emit Transfer(msg.sender, to, value);
//         return true;
//     }

//     function approve(address spender, uint256 value) public returns (bool) {
//         allowance[msg.sender][spender] = value;
//         emit Approval(msg.sender, spender, value);
//         return true;
//     }

//     function transferFrom(address from, address to, uint256 value) public returns (bool) {
//         require(balanceOf[from] >= value, "Insufficient balance");
//         require(allowance[from][msg.sender] >= value, "Not allowed to transfer this much");
//         balanceOf[from] -= value;
//         balanceOf[to] += value;
//         allowance[from][msg.sender] -= value;
//         emit Transfer(from, to, value);
//         return true;
//     }
// }


contract DataReachToken {
    string public name = "DATAREACH AI";
    string public symbol = "DATAI";
    uint256 public totalSupply ; // Total supply in wei

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply) {
        totalSupply=initialSupply;
        balanceOf[msg.sender] = initialSupply; // Allocate initial supply to contract deployer
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Not allowed to transfer this much");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}
