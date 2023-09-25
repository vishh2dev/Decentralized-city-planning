// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CityPlanningGovernance {
    address public owner;

    struct MasterPlan {
        string planName;
        string description;
        bool finalized;
        uint256 totalLandDetails;
        mapping(uint256 => LandDetail) landDetails;
    }

    struct LandDetail {
        string parcelName;
        address owner;
        string landUsage;
        bool approved;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(address => bool) voters;
    }

    mapping(uint256 => MasterPlan) public cityMasterPlans;
    uint256 public totalMasterPlans;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function createMasterPlan(
        string memory _planName,
        string memory _description
    ) public onlyOwner {
        uint256 planId = totalMasterPlans++;
        MasterPlan storage newPlan = cityMasterPlans[planId];
        newPlan.planName = _planName;
        newPlan.description = _description;
        newPlan.finalized = false;
    }

    function updateLandDetails(
        uint256 _planId,
        string memory _planName,
        string memory _landUsage
    ) public {
        require(_planId < totalMasterPlans, "Invalid master plan ID");
        MasterPlan storage plan = cityMasterPlans[_planId];
        require(
            !plan.finalized,
            "The master plan is finalized and cannot be modified"
        );
        uint256 landId = plan.totalLandDetails++;
        LandDetail storage land = plan.landDetails[landId];
        land.parcelName = _planName;
        land.landUsage = _landUsage;
        land.approved = false;
    }

    function voteOnLandDetail(
        uint256 _planId,
        uint256 _parcelId,
        bool _approve
    ) public {
        MasterPlan storage plan = cityMasterPlans[_planId];
        require(
            !plan.finalized,
            "The master plan is finalized and cannot be modified"
        );
        LandDetail storage parcel = plan.landDetails[_parcelId];
        require(!parcel.voters[msg.sender], "You have already voted");
        parcel.voters[msg.sender] = true;

        if (_approve) {
            parcel.yesVotes++;
        } else {
            parcel.noVotes++;
        }
    }

    function finalizeMasterPlan(uint256 _planId) public onlyOwner {
        MasterPlan storage plan = cityMasterPlans[_planId];
        require(!plan.finalized, "The master plan is already finalized");

        for (uint256 i = 0; i < plan.totalLandDetails; i++) {
            LandDetail storage parcel = plan.landDetails[i];
            if (parcel.yesVotes > parcel.noVotes) {
                parcel.approved = true;
            }
        }

        plan.finalized = true;
    }

    function getLandDetails(
        uint256 _planId,
        uint256 _parcelId
    )
        public
        view
        returns (
            string memory parcelName,
            address parcelOwner,
            string memory landUsage,
            bool approved
        )
    {
        MasterPlan storage plan = cityMasterPlans[_planId];
        LandDetail storage parcel = plan.landDetails[_parcelId];
        return (
            parcel.parcelName,
            parcel.owner,
            parcel.landUsage,
            parcel.approved
        );
    }
}
