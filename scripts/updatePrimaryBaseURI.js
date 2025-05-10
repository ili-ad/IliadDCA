const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  const newPrimaryURI = "https://bafybeic3w44qrtjdzlhoyhyct2j3b3c77ug7uo3byust6zqzcv4tce2lju.ipfs.dweb.link/";

  const dcaContract = await ethers.getContractAt("IliadDCA", contractAddress);
  const tx = await dcaContract.setPrimaryBaseURI(newPrimaryURI);
  await tx.wait();

  console.log(`Primary Base URI updated to: ${newPrimaryURI}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
