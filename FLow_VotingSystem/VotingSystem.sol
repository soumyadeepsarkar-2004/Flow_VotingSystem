// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingSystem {
    address public admin;
    uint public proposalCount;

    struct Proposal {
        uint id;
        string description;
        uint voteCount;
    }

    mapping(uint => Proposal) public proposals;
    mapping(address => bool) public hasVoted;

    event ProposalCreated(uint id, string description);
    event VoteCasted(address voter, uint proposalId);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    function createProposal(string memory description) public onlyAdmin {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0);
        emit ProposalCreated(proposalCount, description);
    }

    function vote(uint proposalId) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(proposalId > 0 && proposalId <= proposalCount, "Invalid proposal");

        proposals[proposalId].voteCount++;
        hasVoted[msg.sender] = true;

        emit VoteCasted(msg.sender, proposalId);
    }

    function getWinner() public view returns (string memory description, uint voteCount) {
        uint winningVoteCount = 0;
        uint winningProposalId = 0;

        for (uint i = 1; i <= proposalCount; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }

        return (proposals[winningProposalId].description, winningVoteCount);
    }
}