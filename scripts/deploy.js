const {ethers} = require("hardhat");

async function main() {

  const cityPlaning = await ethers.getContractFactory("CityPlanningGovernance");

  const cityPlaning_contract = await cityPlaning.deploy();
  console.log("Contract deployed to address:", cityPlaning_contract.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });