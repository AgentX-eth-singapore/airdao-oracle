// Sources flattened with hardhat v2.22.11 https://hardhat.org

// SPDX-License-Identifier: MIT

// File contracts/oracle.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;

contract GeneralizedOracle {

    struct Request {
        uint256 requestId;
        address requester;
        string sourceCodeURL; // Off-chain storage link (e.g., IPFS URL)
        bytes callbackFunctionSignature; // Encoded callback function signature
        bool isFulfilled;
    }

    uint256 public currentRequestId;
    mapping(uint256 => Request) public requests;

    event OracleRequest(uint256 requestId, string sourceCodeURL, bytes callbackFunctionSignature);
    event OracleResponse(uint256 requestId, bytes result);

    // Function for users to register their source code for off-chain execution
    function registerSourceCode(string memory sourceCodeURL, bytes memory callbackFunctionSignature) public returns (uint256) {
        currentRequestId++;

        requests[currentRequestId] = Request({
            requestId: currentRequestId,
            requester: msg.sender,
            sourceCodeURL: sourceCodeURL,
            callbackFunctionSignature: callbackFunctionSignature,
            isFulfilled: false
        });

        // Emit event for oracles to listen and execute the source code
        emit OracleRequest(currentRequestId, sourceCodeURL, callbackFunctionSignature);

        return currentRequestId;
    }

    // Oracle nodes will call this function to submit the result after execution
    function respondToRequest(uint256 requestId, bytes memory result) public {
        Request storage req = requests[requestId];

        require(!req.isFulfilled, "Request already fulfilled");

        // Mark as fulfilled
        req.isFulfilled = true;

        // Emit event so that the result is publicly available
        emit OracleResponse(requestId, result);

        // Call the original contract’s callback function with the result
        (bool success,) = req.requester.call(abi.encodePacked(req.callbackFunctionSignature, result));
        require(success, "Callback failed");
    }
}
