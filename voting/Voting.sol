// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    enum VoteStates {
        Absent,
        Yes,
        No
    }

    // min of votes to a proposal be executed
    uint constant VOTE_THRESHOLD = 10;

    // proposal struct
    struct Proposal {
        address target;
        bytes data;
        bool executed;
        uint yesCount;
        uint noCount;
        mapping(address => VoteStates) voteStates;
    }

    // array of objects of proposals
    Proposal[] public proposals;

    // events
    event ProposalCreated(uint);
    event VoteCast(uint, address indexed);

    // members that are allowed to create new proposals
    mapping(address => bool) members;

    // on contract deployment, set the allowed members to create proposals
    constructor(address[] memory _members) {
        for (uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        members[msg.sender] = true;
    }

    /**
     * create a new proposal, if it has been issued also emit an event. To an address create a proposal, he must
     * to be part of the members.
     * @param _target who's the proposal creator
     * @param _data when proposal will be executed
     */
    function newProposal(address _target, bytes calldata _data) external {
        // require that user is a member, if it's, emit an event
        require(members[msg.sender]);
        emit ProposalCreated(proposals.length);

        // storage proposal's details
        Proposal storage proposal = proposals.push();
        proposal.target = _target;
        proposal.data = _data;
    }

    /**
     * really vote, the voter must to be part of members
     * @param _proposalId proposal identification
     * @param _supports if supports or not the proposal (true for yes, false for)
     */
    function castVote(uint _proposalId, bool _supports) external {
        // voter must to be part of members
        require(members[msg.sender]);

        // create an array object
        Proposal storage proposal = proposals[_proposalId];

        // clear out previous vote
        if (proposal.voteStates[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
        }
        if (proposal.voteStates[msg.sender] == VoteStates.No) {
            proposal.noCount--;
        }

        // add new vote
        if (_supports) {
            proposal.yesCount++;
        } else {
            proposal.noCount++;
        }

        // we're tracking whether or not someone has already voted
        // and we're keeping track as well of what they voted
        proposal.voteStates[msg.sender] = _supports
            ? VoteStates.Yes
            : VoteStates.No;

        // emit an event with proposal and voter
        emit VoteCast(_proposalId, msg.sender);

        // if it reachs the number of votes, execute the proposal
        if (proposal.yesCount == VOTE_THRESHOLD && !proposal.executed) {
            (bool success, ) = proposal.target.call(proposal.data);
            require(success);
        }
    }
}
