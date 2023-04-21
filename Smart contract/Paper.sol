// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import "hardhat/console.sol";

contract Research{
    // uint public paperId;
    uint public totalChunks;
    // address payable public publisherAddr;

    // struct Paper{
    //     uint Id;
    //     string content;
    //     address owner;
    // }

    // mapping(address => Paper[]) public publisher;

    mapping(string => uint) public chunks;

    // constructor(string[] memory chunkArr){
    //     for(uint i = 0; i < chunkArr.length; i++){
    //         totalChunks++;
    //         chunks[chunkArr[i]] = 1;
    //         console.log("%d is val", chunks[chunkArr[i]]);
    //     }
    // }


    // events
    event validation(address indexed sender, bool isValid,uint plag_percent);

// takes input as array of string and returns bool
    function validate(string[] memory _contentHash) public returns(bool){
        string[] memory arr = _contentHash;
        uint percentPlag = plagarism(_contentHash);

        if(percentPlag < 20){
            uint n = arr.length;
            for(uint i = 0; i < n; i++){
                if(chunks[arr[i]] == 0){
                    update(_contentHash[i], 1);
                    totalChunks++;
                }
            }
            emit validation(msg.sender, true,percentPlag);
            return true;
        }
        emit validation(msg.sender, false,percentPlag);
        return false;
    }

// this function update the mapping and add chunks
    function update(string memory key, uint value) private{
        chunks[key] = value;
    }

// checks plagiarism 
    function plagarism(string[] memory _contentHash) public view returns(uint){
        uint count = 0;
        uint n = _contentHash.length;
        for(uint i = 0; i < n; i++){
            if(chunks[_contentHash[i]] == 1){
                count++;
            }
        }

        return (count*100/n);
    }
}