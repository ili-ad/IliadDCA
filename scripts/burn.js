const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  const [signer] = await ethers.getSigners();
  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress, signer);

  const tokenId = 1; // assuming the first minted token has ID 1

  const tx = await dcaContract.burn(tokenId);
  await tx.wait();

  console.log(`✅ Token ${tokenId} burned.`);
}

main().catch((error) => {
  console.error("❌ Error:", error);
  process.exitCode = 1;
});
