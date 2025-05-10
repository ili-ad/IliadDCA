const { docgen } = require("solidity-docgen");
const path = require("path");
const fs = require("fs");

async function main() {
  try {
    const projectRoot = path.resolve(__dirname, "..");
    const solcOutputPath = path.join(projectRoot, "build/contracts");
    const contractsDir = path.join(projectRoot, "contracts");
    const outputDir = path.resolve(__dirname, "../docs");

    // Ensure the output directory exists
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    console.log("Solidity output path:", solcOutputPath);
    console.log("Contracts directory:", contractsDir);
    console.log("Output directory:", outputDir);

    //const files = fs.readdirSync(solcOutputPath);
    //console.log("Files in solcOutputPath:", files);
    const files = fs.readdirSync(solcOutputPath).filter(file => file.endsWith('.json'));
    console.log("Filtered files in solcOutputPath:", files);

    files.forEach(file => {
      const filePath = path.join(solcOutputPath, file);
      const content = fs.readFileSync(filePath, 'utf-8');
      try {
        JSON.parse(content);
        console.log(`${file} is valid JSON`);
      } catch (error) {
        console.error(`${file} is invalid JSON:`, error.message);
      }
    });
    
    // Validate contract JSON
    const contractPath = path.join(solcOutputPath, "IliadDCO.json");
    if (!fs.existsSync(contractPath)) {
      throw new Error(`Contract JSON file not found: ${contractPath}`);
    }
    const contractJson = JSON.parse(fs.readFileSync(contractPath, "utf-8"));
    console.log("Contract JSON loaded successfully:", contractJson.contractName);

    await docgen(
      [{ output: solcOutputPath }],
      {
        input: contractsDir,
        output: outputDir,
      }
    );

    console.log(`Documentation generated successfully at ${outputDir}`);
  } catch (error) {
    console.error("Error generating documentation:", error.message);
  }
}

main();
