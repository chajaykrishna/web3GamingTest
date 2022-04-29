
const hre = require("hardhat");

async function main() {
  const Gambling = await hre.ethers.getContractFactory("Gambling");
  const gambling = await Gambling.deploy();

  await gambling.deployed();

  console.log("Greeter deployed to:", gambling.address);
  console.time('getUploadRead');
  for (let i = 0; i < 100; i++) {
    const tx = await gambling.deposit({value: hre.ethers.utils.parseEther("0.000001")});
    console.log(i+": "+ tx.hash);
    }
    console.timeEnd('getUploadRead');
}



main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

