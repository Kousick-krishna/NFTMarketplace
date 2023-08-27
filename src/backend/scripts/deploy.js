const { ethers } = require("ethers");

async function main(){
  const [deployer] = await ethers.getSigners();

  console.log("Deploying with the account", deployer.address);
  console.log("Deployer Account:",(await deployer.getBalance()).toString());
  //loading contracts
  const NFT = await ethers.getContractFactory("NFT");
  const Marketplace = await ethers.getContractFactory("Marketplace");
  //deploying contracts
  const nft = await NFT.deploy();
  const marketplace = await Marketplace.deploy(1);

  saveFrontendFiles(marketplace, "Marketplace");
  saveFrontendFiles(nft,"NFT");
}

function saveFrontendFiles(contract,name){
  const fs = require("fs");
  const contractdir = __dirname+"/../../frontend/contractsdata";

  if(!fs.existsSync(contractdir)){
    fs.mkdirSync(contractdir);
  }

  fs.writeFileSync(
    contractdir+`/${name}-address.json`,
    JSON.stringify({address : contract.address},undefined,2)
  );

  const contractartifact = artifacts.readArtifactSync(name);

  fs.writeFileSync(
    contractdir+`/${name}.json`,
    JSON.stringify(contractartifact,null,2)
  );
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
.then(() => process.exitCode =0)
.catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
