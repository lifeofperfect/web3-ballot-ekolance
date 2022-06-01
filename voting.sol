// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IVotingContract{

//only one address should be able to add candidates
    function addCandidate(uint _candidateId) external returns(bool);

    
    function voteCandidate(uint candidateId) external returns(bool);

    //getWinner returns the name of the winner
    function getWinner() external returns(uint);
}

contract Balllot is IVotingContract {
    mapping(address => bool) private candidateVote;
    uint private candidateTime;
    address private creator;
    

    struct Candidate{
        uint candidateId;
        uint voteCount;
    }

    Candidate[] private candidates;
    mapping(address => bool) private voter;

    
    constructor(uint _candidateTime){
        candidateTime = block.timestamp + _candidateTime;
        creator = msg.sender;
    }

    function addCandidate(uint _candidateId) external returns(bool){
        if(block.timestamp > candidateTime){
            revert("Time has ended for adding candidate");
        }

        require(msg.sender == creator, "You are not authorized");

        

        candidates.push(Candidate({
            candidateId: _candidateId,
            voteCount: 0
        }));

        

        return true;

    }

    function voteCandidate(uint candidateId) external returns(bool){
        //require(voter[msg.sender] != false, "You have previously voted");

        if(block.timestamp < candidateTime){
            revert("voting yet to start");
        }

        if(block.timestamp > candidateTime * 2){
            revert("Time has ended for voting candidate");
        }

        if(voter[msg.sender] == true){
            revert("You cant vote more than once");
        }

        voter[msg.sender] = true;
        candidates[candidateId].voteCount +=1;

        return true;

    }

    function getWinner() external view returns(uint){
        if(block.timestamp < candidateTime * 2){
            revert("Not yet time to see the result");
        }
        uint maxNumber = 0;
        uint tempi = 0;
        for(uint i=0; i< candidates.length; i++){
            if(candidates[i].voteCount > maxNumber){
                maxNumber = candidates[i].voteCount;
                tempi = i;
            }
        }
        
        return candidates[tempi].candidateId;
    }
}
