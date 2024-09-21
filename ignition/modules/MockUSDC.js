import { buildModule } from "@ignoredlabs/hardhat-ignition";

export default buildModule("MockUSDC", async (m) => {
  // Get the constructor argument: initialSupply (e.g., 1,000,000 USDC)
  const initialSupply = m.contractArgument("initialSupply", "1000000");

  // Deploy the contract
  const mockUSDC = await m.deploy("MockUSDC", {
    args: [initialSupply],
  });

  // Log the deployed contract address
  m.logger.success(`MockUSDC deployed at address: ${mockUSDC.address}`);
});
