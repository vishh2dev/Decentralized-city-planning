require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config()

const API_URL = process.env.API_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY;


module.exports = {
  defaultNetwork:"polygon_mumbai",
  networks:{
    hardhat:{
    },
     polygon_mumbai:{
      url:API_URL,
      accounts:[`0x${PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY
  },
  solidity:{
    version: "0.8.19",
    settings:{
      optimizer:{
        enabled:true,
        runs:200
      }
    }
  } ,
};
