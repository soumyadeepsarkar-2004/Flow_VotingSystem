# 🗳️ Voting System Smart Contract (Flow EVM Testnet)

## 📖 Overview

This project demonstrates a simple **Voting System Smart Contract** built using **Solidity** and deployed on the **Flow EVM Testnet**.  
The contract allows an **admin** to create proposals, while users can **vote** once per proposal.  
Votes are counted on-chain, and the winning proposal can be retrieved at any time.

---

## ⚙️ Smart Contract Details

- **Contract Name:** `VotingSystem`
- **Language:** Solidity (`^0.8.20`)
- **Network:** Flow EVM Testnet  
- **Contract Address:** [`0x6453B47784d27004caf193A6d44034D5991fF057`](https://evm-testnet.flow.com/address/0x6453B47784d27004caf193A6d44034D5991fF057)
- **License:** MIT

---

## 📂 Features

- 👑 **Admin Control** – Only the deployer (admin) can create proposals.  
- 🗳️ **One Vote Per Address** – Prevents duplicate voting.  
- 📊 **Real-Time Vote Counting** – Keeps track of all votes on-chain.  
- 🏆 **Winner Retrieval** – Returns the proposal with the highest votes.  
- 🔊 **Event Logging** – Emits events for proposals and votes for easy tracking in block explorers.

---

## 🧠 Smart Contract Code

```solidity
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

| Layer                  | Technology         |
| ---------------------- | ------------------ |
| **Smart Contract**     | Solidity (v0.8.20) |
| **Blockchain Network** | Flow EVM Testnet   |
| **Deployment Tool**    | Remix IDE          |
| **Wallet**             | MetaMask           |
| **Explorer**           | Flow EVM Explorer  |
| **License**            | MIT                |


```

## 🚀 Future Improvements

- Add proposal time limits and voting deadlines

- Implement multiple votes per address (weighted voting)

- Create a React.js frontend to interact with the contract

- Store proposal metadata (like titles/descriptions) on IPFS

- Integrate Flow Explorer API for on-chain analytics
