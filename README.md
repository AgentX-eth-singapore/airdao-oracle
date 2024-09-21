# Custom Generalized Oracle & Prediction Market System (Polymarket)

This project demonstrates a simple decentralized oracle network (DON) where users can submit off-chain source code for execution by oracle nodes. The system allows smart contracts to interact with external data via oracle nodes, which fetch, execute, and return results to the requesting contract.

## Project Structure

<img width="1485" alt="Screenshot 2024-09-22 at 5 12 51 AM" src="https://github.com/user-attachments/assets/4ffad9ec-2d2a-43f6-b97f-125670806cc5">


### 1. **GeneralizedOracle.sol**
This contract allows users to register a request for off-chain code execution by providing:
- A URL to the source code (e.g., IPFS link).
- The encoded callback function signature from the requesting contract.

Oracle nodes listen for these requests, execute the source code in a sandbox, and return the result on-chain.

### 2. **PredictionMarket.sol**
This is a sample contract that integrates with the **GeneralizedOracle** contract. It uses the oracle to fetch and execute predictions based on external data. Once the oracle has processed the data, it calls back a function in the **PredictionMarket** contract to update the result.

## System Flow

### 1. **Register a Request**
A contract (such as `PredictionMarket.sol`) calls the `registerSourceCode()` function in the **GeneralizedOracle** contract. This function takes two parameters:
- A `sourceCodeURL` string, which points to the location of the off-chain source code (e.g., an IPFS URL).
- A `callbackFunctionSignature`, which is the encoded signature of the function in the calling contract that will handle the result.

Example:
```solidity
function requestOracle() public {
    GeneralizedOracle oracle = GeneralizedOracle(oracleAddress);
    
    string memory sourceCodeURL = "https://ipfs.io/ipfs/QmYourSourceCodeHash";
    bytes memory callbackSignature = getEncodedCallback();

    oracle.registerSourceCode(sourceCodeURL, callbackSignature);
}
```

The oracle emits an OracleRequest event that off-chain nodes listen to.

## 2. Oracle Node Execution
Off-chain oracle nodes pick up the OracleRequest event, fetch the source code from the provided URL, and execute the logic. After execution, the result is encoded and sent back on-chain by calling the `respondToRequest()` function in the GeneralizedOracle contract.

### Example:
```javascript
const result = 42; // Simulated result
const encodedResult = ethers.utils.defaultAbiCoder.encode(["uint256"], [result]);
const tx = await oracleContract.respondToRequest(requestId, encodedResult);
await tx.wait();
```

## 3. Callback in the Requesting Contract
Once the oracle processes the request, it calls the `oracleCallback()` function in the requesting contract (e.g., `PredictionMarket.sol`). The function signature and result are passed, and the contract handles the result.

### Example:
```solidity
function oracleCallback(uint256 result) external {
    require(msg.sender == oracleAddress, "Unauthorized oracle");
    predictionOutcome = result;
}
```

## Deployment & Testing

### 1. Deploy **GeneralizedOracle**
Deploy the **GeneralizedOracle** contract and note its address.

### 2. Deploy **PredictionMarket**
Deploy the **PredictionMarket** contract, passing the address of the deployed **GeneralizedOracle** contract to its constructor.

### Example:
```solidity
PredictionMarket market = new PredictionMarket("0xYourOracleContractAddress");
```

### 3. Simulate a Request
From the **PredictionMarket** contract, call the `requestOracle()` function to register a new request with the oracle.

### 4. Simulate Off-Chain Oracle Response
Simulate the off-chain oracle node fetching the request, executing the code, and responding with the result by calling `respondToRequest()` in the **GeneralizedOracle** contract.

### Example:
```solidity
oracle.respondToRequest(1, abi.encode(42));
```

This will call the callback function in **PredictionMarket** and update the `predictionOutcome` variable.

## Example Inputs

### Registering a Request:
```solidity
string memory sourceCodeURL = "https://ipfs.io/ipfs/Qm<>";
bytes memory callbackSignature = hex"03e78d5d";  // Encoded callback signature
```

### Morph Contracts

1. **mockUsdc**  
   [View on Morph Explorer](https://explorer-holesky.morphl2.io/address/0x632654Be7eA0625DEa3D12857887Acb76dc3AE1b?tab=contract)

2. **Predict and Earn (Polymarket)**  
   [View on Morph Explorer](https://explorer-holesky.morphl2.io/address/0xA524319d310fa96AAf6E25F8af729587C2DEaE8a)

3. **Generalized Oracle**  
   [View on Morph Explorer](https://explorer-holesky.morphl2.io/address/0xf8B4f97d5AD7f3754a0d67E674b9692AA518514F?tab=txs)

### AirDAO Contracts

1. **Generalized Oracle**  
   [View on AirDAO Explorer](https://airdao.io/explorer/address/0x8fB873e697a106e7Dd819547587AcAEf0840E835/)

2. **MockUsdc***  
   [View on AirDAO Explorer](https://airdao.io/explorer/address/0x54d562B3a8b680F8a21D721d22f0BB58A3787555/)

3. **Predict and Earn**  
   [View on AirDAO Explorer](https://airdao.io/explorer/address/0x97363b585B6540038993Cc8D2443F902A7E3a69D/)

