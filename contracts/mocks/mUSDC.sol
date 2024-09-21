// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
    constructor(uint256 initialSupply) ERC20("Mock USDC", "USDC") {
        _mint(msg.sender, initialSupply);
    }

    // Override to set the number of decimals to 6, like USDC
    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    // Function to mint new tokens (for testing purposes)
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    // Function to burn tokens (for testing purposes)
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
