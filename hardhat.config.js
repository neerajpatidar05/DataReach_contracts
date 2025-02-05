// require("@nomiclabs/hardhat-ethers");
// require("@nomicfoundation/hardhat-toolbox");

// module.exports = {
//   solidity: "0.8.24",
//   networks: {
//     hardhat: {},
//     sepolia: {
//         url: "https://sepolia.infura.io/v3/c0d50466302c47fb870bf58cc969f745",
//         accounts: [`207e6095113e565a9b0413d59ceabf431d13e140d6fa18c85c7b7653cd3aeb59`]
//       },
//     bscTestnet: {
//       url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
//       accounts: [`0x${YOUR_PRIVATE_KEY}`]
//     },
//     bscMainnet: {
//       url: "https://bsc-dataseed.binance.org/",
//       accounts: [`0x${YOUR_PRIVATE_KEY}`]
//     }
//   }
// };




require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config(); 
const PrivateKey=process.env.PRIVATE_KEY
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "testnet",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
    },

    testnet: {
      url: process.env.PULSETEST_NODE_URL,
      chainId: 11155111.,
      accounts: [process.env.PRIVATE_KEY]
    }
    },
  solidity: {
  version: "0.8.20",
  settings: {
    optimizer: {
      enabled: true
    }
   }
  },
  paths: {
    sources: "./contracts",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  }
};
