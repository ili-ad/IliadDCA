const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  const newBackupURI = "https://bafybeic3w44qrtjdzlhoyhyct2j3b3c77ug7uo3byust6zqzcv4tce2lju.ipfs.dweb.link/";

  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress);
  const tx = await dcaContract.setBackupBaseURI(newBackupURI);
  await tx.wait();

  console.log(`Backup Base URI updated to: ${newBackupURI}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
