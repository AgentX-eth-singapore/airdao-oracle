async function main() {
  const contractAddress = process.env.CONTRACT_ADDRESS; // Add your deployed contract address in the .env
  const initialSupply = "1000000"; // Same value used for deployment

  console.log(`Verifying contract at ${contractAddress}...`);

  try {
    await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments: [initialSupply], // Constructor arguments to verify the contract
    });
    console.log("Contract verified successfully!");
  } catch (error) {
    console.error("Verification failed:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
