const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  
  // Correct way to explicitly get signer and pass to getContractAt
  const [signer] = await ethers.getSigners();
  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress, signer);

  const recipient = signer.address; // minting to your own wallet for simplicity
  const tokenPath = "1.json";

  const tx = await dcaContract.mint(recipient, tokenPath);
  await tx.wait();

  console.log(`Minted Token to: ${recipient} with path: ${tokenPath}`);
}

main().catch((error) => {
  console.error("❌ Error:", error);
  process.exitCode = 1;
});
