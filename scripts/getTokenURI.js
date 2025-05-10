const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  const tokenId = 1;  // replace with your token ID

  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress);

  const uri = await dcaContract.tokenURI(tokenId);
  console.log(`Token URI: ${uri}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
