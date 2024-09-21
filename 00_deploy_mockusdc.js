// module.exports = async ({ getNamedAccounts, deployments }) => {
//   const { deploy } = deployments;
//   const { deployer } = await getNamedAccounts();

//   // Specify the initial supply for the Mock USDC token (e.g., 1 million USDC with 6 decimals)
//   const initialSupply = "1000000";

//   // Deploy MockUSDC contract
//   const mockUSDC = await deploy("MockUSDC", {
//     from: deployer,
//     args: [initialSupply], // Pass the initial supply as constructor argument
//     log: true, // Logs deployment details to the console
//   });

//   console.log(`MockUSDC deployed at address: ${mockUSDC.address}`);
// };
