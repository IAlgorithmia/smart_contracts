// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CrowdfundingPlatform {
    // Struct for storing information about each campaign
    struct Campaign {
        address payable owner;   // Campaign owner who can withdraw funds if the goal is met
        uint goal;               // Funding goal in wei
        uint deadline;           // Campaign deadline as a UNIX timestamp
        uint pledgedAmount;      // Total funds pledged by contributors
        bool claimed;            // Flag to check if funds were claimed by the owner
    }

    // Mapping to store details of each campaign using a unique campaign ID
    mapping(uint => Campaign) public campaigns;
    uint public campaignCount;

    // Nested mapping to store how much each contributor has pledged for each campaign
    mapping(uint => mapping(address => uint)) public contributions;

    // Events to log important actions for off-chain indexing and notifications
    event CampaignCreated(uint campaignId, address owner, uint goal, uint deadline);
    event Pledged(uint campaignId, address contributor, uint amount);
    event Withdrawn(uint campaignId, address owner, uint amount);
    event Refunded(uint campaignId, address contributor, uint amount);

    // Modifier to ensure only the owner of a campaign can call specific functions
    modifier onlyOwner(uint _campaignId) {
        require(msg.sender == campaigns[_campaignId].owner, "Not campaign owner");
        _;
    }

    // Modifier to ensure a campaign has not reached its deadline
    modifier beforeDeadline(uint _campaignId) {
        require(block.timestamp < campaigns[_campaignId].deadline, "Campaign has ended");
        _;
    }

    // Modifier to ensure a campaign has reached its deadline
    modifier afterDeadline(uint _campaignId) {
        require(block.timestamp >= campaigns[_campaignId].deadline, "Campaign is still ongoing");
        _;
    }

    // Function to create a new campaign
    function createCampaign(uint _goal, uint _duration) external {
        require(_goal > 0, "Goal must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        uint deadline = block.timestamp + _duration;
        campaigns[campaignCount] = Campaign({
            owner: payable(msg.sender),
            goal: _goal,
            deadline: deadline,
            pledgedAmount: 0,
            claimed: false
        });
        
        emit CampaignCreated(campaignCount, msg.sender, _goal, deadline);
        campaignCount++;
    }

    // Function to pledge funds to a specific campaign
    function pledge(uint _campaignId) external payable beforeDeadline(_campaignId) {
        require(msg.value > 0, "Pledge must be greater than 0");
        
        Campaign storage campaign = campaigns[_campaignId];
        campaign.pledgedAmount += msg.value;
        contributions[_campaignId][msg.sender] += msg.value;

        emit Pledged(_campaignId, msg.sender, msg.value);
    }

    // Function to withdraw funds if the campaign goal is met
    function withdrawFunds(uint _campaignId) external onlyOwner(_campaignId) afterDeadline(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.pledgedAmount >= campaign.goal, "Goal not met");
        require(!campaign.claimed, "Funds already claimed");

        uint amount = campaign.pledgedAmount;
        campaign.claimed = true;
        campaign.owner.transfer(amount);

        emit Withdrawn(_campaignId, campaign.owner, amount);
    }

    // Function to request a refund if the campaign failed to meet its goal
    function requestRefund(uint _campaignId) external afterDeadline(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.pledgedAmount < campaign.goal, "Campaign was successful");

        uint contributedAmount = contributions[_campaignId][msg.sender];
        require(contributedAmount > 0, "No contributions to refund");

        contributions[_campaignId][msg.sender] = 0;
        payable(msg.sender).transfer(contributedAmount);

        emit Refunded(_campaignId, msg.sender, contributedAmount);
    }

    // View function to get information about a specific campaign
    function getCampaign(uint _campaignId) external view returns (
        address owner,
        uint goal,
        uint deadline,
        uint pledgedAmount,
        bool claimed
    ) {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.owner,
            campaign.goal,
            campaign.deadline,
            campaign.pledgedAmount,
            campaign.claimed
        );
    }

    // View function to check the contribution of a user to a specific campaign
    function getContribution(uint _campaignId, address _contributor) external view returns (uint) {
        return contributions[_campaignId][_contributor];
    }
}
