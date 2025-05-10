const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;

  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress);
  
  const primaryURI = "https://bafybeiapveineiglhre2mnxuwrfwwpumuywezs3xavjfaglf6fgra3bj7m.ipfs.dweb.link/contract.json";
  const backupURI = "https://bafybeiapveineiglhre2mnxuwrfwwpumuywezs3xavjfaglf6fgra3bj7m.ipfs.dweb.link/contract.json";

  // Set Primary Contract URI
  let tx = await dcaContract.setContractURI(primaryURI);
  await tx.wait();
  console.log(`Primary Contract URI updated to: ${primaryURI}`);

  // Set Backup Contract URI
  tx = await dcaContract.setBackupContractURI(backupURI);
  await tx.wait();
  console.log(`Backup Contract URI updated to: ${backupURI}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
