module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log(`Deploying contracts with the account: ${deployer}`);

  // 1. Deploy GeneralizedOracle Contract
  const generalizedOracle = await deploy("GeneralizedOracle", {
    from: deployer,
    log: true,
  });
  console.log(`GeneralizedOracle deployed at: ${generalizedOracle.address}`);

  // 2. Deploy USDC mock contract or use existing one
  const usdcAddress = "0x54d562B3a8b680F8a21D721d22f0BB58A3787555"; // Replace with actual USDC address

  // 3. Deploy PredictAndEarn Contract
  const question = "Which team will win the match?";
  const outcomeA = "Team A";
  const outcomeB = "Team B";

  const predictAndEarn = await deploy("PredictAndEarn", {
    from: deployer,
    args: [
      usdcAddress,
      generalizedOracle.address,
      question,
      outcomeA,
      outcomeB,
    ],
    log: true,
  });
  console.log(`PredictAndEarn deployed at: ${predictAndEarn.address}`);
};
