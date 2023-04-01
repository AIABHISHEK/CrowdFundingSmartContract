// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {

    struct Campaign{
        // owner address;
        address owner;
        string title;
        string description;
        // target amount we want to achieve
        uint256 target;
        // amount collected
        uint256 deadline;
        uint256 amountCollected;
        // url of image
        string image;
        address[] donators;
        uint256[] donations;
    }

    uint256 public numberOfCampaigns = 0;

    // create mapping to store the number of Campaign
    mapping (uint256 => Campaign) campaigns;
    constructor() {
        
    }

    function createCampaign(address _owner, string memory _title, string memory _image, uint256 _target, uint256 _deadline, string memory _description)  public returns(uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // if required condition met 
        require(campaign.deadline < block.timestamp, "deadline should be a date in future");
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.deadline = _deadline;
        campaign.description = _description;
        campaign.target = _target;
        campaign.image = _image;
        campaign.amountCollected = 0;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id /*id of campaign to which to donate*/) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
        //payable function sends amount of donatio to campaign owner 
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if(sent){
            campaign.amountCollected += amount;
        }
        
    }
    function getDonators(uint256 _id /*id of campaign of which we want the donators */) view public returns (address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() view public returns (Campaign[] memory) {
        // declare an array of Campaign type and storing all the campaigns in that array
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}