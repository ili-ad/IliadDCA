const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  
  // Set the switch date clearly to 60 days from now
  const currentTime = Math.floor(Date.now() / 1000); // current timestamp in seconds
  const sixtyDaysInSeconds = 60 * 24 * 60 * 60;      // 60 days
  const newSwitchDate = currentTime + sixtyDaysInSeconds;

  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress);

  const tx = await dcaContract.setSwitchDate(newSwitchDate);
  await tx.wait();

  console.log(`✅ Switch Date updated successfully to: ${new Date(newSwitchDate * 1000).toISOString()}`);
}

main().catch((error) => {
  console.error("❌ Error occurred:", error);
  process.exitCode = 1;
});
