const { ethers, upgrades } = require("hardhat");

async function main() {
  //const PROXY_ADDRESS = "0x04F559734cd49906Ce02F7128F76dE7E3fe79476"; // Replace with your deployed proxy address
  const contractAddress = process.env.DEPLOYED_CONTRACT_ADDRESS;
  console.log("Deploying new implementation contract...");
  const IliadDCA = await ethers.getContractFactory("IliadDCA");
  const upgraded = await upgrades.upgradeProxy(contractAddress, IliadDCA);

  console.log("Contract upgraded at:", await upgraded.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
