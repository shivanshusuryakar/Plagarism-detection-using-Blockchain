// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import "hardhat/console.sol";

contract Research{
    // uint public paperId;
    uint public totalChunks;
    
    struct Ans{
        bool isValid;
        uint plagiarism;
    }

    mapping(string => uint) public chunks;

    // events
    event validation(address indexed sender, bool isValid, uint percentPlag);
    event plag_detect(uint[] plag_part);

// takes input as array of string and returns bool
    function validate(string[] memory _contentHash) public returns(bool){
        string[] memory arr = _contentHash;
        uint n = _contentHash.length;

        uint percentPlag = plagarism(_contentHash, n);
        
        if(percentPlag < 20){
            uint n1 = arr.length;
            for(uint i = 0; i < n1; i++){
                if(chunks[arr[i]] == 0){
                    update(_contentHash[i], 1);
                    totalChunks++;
                }
            }
            emit validation(msg.sender, true, percentPlag);
            return true;
        }
        emit validation(msg.sender, false, percentPlag);
        return false;
    }

// this function update the mapping and add chunks
    function update(string memory key, uint value) private{
        chunks[key] = value;
    }

// checks plagiarism 
    function plagarism(string[] memory _contentHash, uint n) public returns(uint percent){
        uint count = 0;  
        uint[] memory plag_part = new uint[](n);
        uint ind=0;
        for(uint i = 0; i < n; i++){
            if(chunks[_contentHash[i]] == 1){
                count++;
                plag_part[ind++] = i+1;
            }
        }

        emit plag_detect(plag_part);
        return (count*100/n);
    }
}