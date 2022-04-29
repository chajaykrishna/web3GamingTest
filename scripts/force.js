const GamblingAbi = require("../artifacts/contracts/Gambling.sol/Gambling.json");
const ethers = require("ethers");
const hre = require("hardhat");

const floodContract = async () =>{
    const API_KEY = "0u1ZZTenEuNYYTnQvtPyX3PxGVLjSQ6s";
    const PRIVATE_KEY = "0x989460de805ab9c895ab41f0d655fa68c19d91a6f5abf5ad9b34d27af4bacb2f"
    const gamblingAddress = "0x71905c753548db863F756B82A82f3D19C9D01412";
    const provider = new ethers.providers.AlchemyProvider(network="maticmum" , API_KEY);
    const signer = new ethers.Wallet(PRIVATE_KEY, provider);
    const gambling = new ethers.Contract(gamblingAddress, GamblingAbi.abi, signer);
    const tx = []
    console.time();
    for (let i = 0; i < 100; i++) {
         tx[i] =  await gambling.deposit({value: hre.ethers.utils.parseEther("0.000001")});
    }
    console.log(tx.forEach((element, index) => {
        console.log(index+": "+element.hash);}));
}
console.timeEnd();

floodContract().then(()=>{
    console.log("done");
})
.catch((error) => { console.error(error)});