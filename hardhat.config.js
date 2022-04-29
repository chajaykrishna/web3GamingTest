require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const {MumbaiUrl, PrivateKey, RinkebyUrl} = process.env;

  

module.exports = {
  solidity: "0.8.10",
  defaultNetwork: "hardhat",
  networks: { 
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/0u1ZZTenEuNYYTnQvtPyX3PxGVLjSQ6s",
      accounts: ["0x989460de805ab9c895ab41f0d655fa68c19d91a6f5abf5ad9b34d27af4bacb2f"]
    },
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/Jka7h43Jg5A_mEXlLkMVXv-G-8sOsLJL",
      accounts: ["0x989460de805ab9c895ab41f0d655fa68c19d91a6f5abf5ad9b34d27af4bacb2f"]
    },

    rinkebyInfura: {
      url: "https://rinkeby.infura.io/v3/5ce0020ba6254db188530af826bbeefd",
      accounts: ["0x989460de805ab9c895ab41f0d655fa68c19d91a6f5abf5ad9b34d27af4bacb2f"]
  }
}
};
