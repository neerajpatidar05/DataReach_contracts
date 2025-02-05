
const hre = require("hardhat");
// const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
  
    // Deploy the ERC20 Token
    const Token = await hre.ethers.getContractFactory("DataReachToken");
  //  const initialSupply = ethers.utils.parseUnits('1000000', 18); // 1,000,000 tokens
    // const token = await Token.deploy('1200000000000000000000000000');
    console.log(Token,"token ----");
    // const initialSupply = hre.ethers.utils.parseUnits("1200000", 18); // 1.2 million tokens with 18 decimals
    const initialSupply = "1200000000000000000000000000";
    const token = await Token.deploy(initialSupply);
    console.log("Token deployment transaction:", token.deployTransaction);
    // await token.deployed();
    // await token.deployTransaction;
    await token.deployTransaction.wait();
    console.log("Token deployed to:",token.address);
    console.log("Token deployed to:", token.address);

    // // Define ICO parameters
    // const tokenRate = ethers.utils.parseUnits('1', 18); // 1 BNB per DatareachCoin
    // const startTime = Math.floor(Date.now() / 1000) + 3600; // ICO starts in 1 hour
    // const endTime = startTime + 30 * 24 * 3600; // ICO lasts for 30 days
    // const maxAmount = ethers.utils.parseUnits('10', 'ether'); // Maximum investment per user is 10 BNB
    // const minAmount = hre.ethers.utils.parseUnits('0.1', 'ether'); // Minimum investment per transaction is 0.1 BNB
    // const collectorWallet = deployer.address; // Collector wallet address
  
    // // Deploy the ICO Contract
    // const ICO = await hre.ethers.getContractFactory("DataReachICO");
    // const ico = await ICO.deploy(
    //   token.address,
    //   tokenRate,
    //   startTime,
    //   endTime,
    //   maxAmount,
    //   minAmount,
    //   collectorWallet,
    //   deployer.address
    // );
    // await ico.deployed();
    // console.log("ICO deployed to:", ico.address);
  
    // // Transfer initial supply of tokens to the ICO contract
    // await token.transfer(ico.address, initialSupply);
    // console.log(`Transferred ${initialSupply.toString()} tokens to ICO contract`);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
  