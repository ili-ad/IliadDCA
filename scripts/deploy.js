const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const IliadDCA = await ethers.getContractFactory("IliadDCA");

  const initialBaseURI = "https://bafybeihq5gasfawbkqgaqnr2ajepruyimqhsyuremfm4i2piypl4fptfx4.ipfs.dweb.link/tokens/";
  const backupBaseURI = "https://bafybeihq5gasfawbkqgaqnr2ajepruyimqhsyuremfm4i2piypl4fptfx4.ipfs.dweb.link/tokens/";  
  const initialSwitchDate = Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60); // 30 days from now

  const dcaContract = await upgrades.deployProxy(
    IliadDCA,
    [initialBaseURI, backupBaseURI, initialSwitchDate],
    { initializer: 'initialize' }
  );

  await dcaContract.waitForDeployment();

  console.log("Contract deployed at:", await dcaContract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
