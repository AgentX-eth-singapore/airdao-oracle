require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    hardhat: {
    },
    airdao: {
      url: "https://testnet-rpc.airdao.io/",
      accounts: ["private-key"],
      chainId: 22040
    }
  },

};
