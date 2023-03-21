require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

var INFURA_KEY = "464cd65da94c48ad847f8248e7a8ff61";
const mnemonic = "common choose choose ticket switch hungry year series length analyst trophy library";

module.exports = {
  defaultNetwork: "bsctestnet",
  networks: {
    hardhat: {
    },
    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: { mnemonic: mnemonic }
    },
    bscmainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: { mnemonic: mnemonic }
    }
  },
  etherscan: {
    // Your API key for BSCscan
    // Obtain one at https://bscscan.com/
    apiKey: "TQ3ISSVF7J2UWFTIE93D67MVETJ86WZDMS"
  },
  solidity: {
    compilers: [
      {
        version: "0.8.11",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ],
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  }
}