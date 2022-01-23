const main = async () => {
  
  // get the owner of the contract address[0] and another addr
  const [owner, randomPerson1, randomPerson2] = await hre.ethers.getSigners();
  
  //Get the deployed instance
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy();
  
  // Validate Addresses 
  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave();
  await waveTxn.wait();
  waveCount = await waveContract.getTotalWaves();


  //calling from another address 
  waveTxn = await waveContract.connect(randomPerson1).wave();
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  //calling from another address 
  waveTxn = await waveContract.connect(randomPerson2).wave();
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();


};
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();