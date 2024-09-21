// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract PredictAndEarn {
    address public admin;
    address public oracleAddress;
    bool public marketResolved;
    string public marketQuestion;
    string public correctOutcome;

    struct Outcome {
        string name;
        uint256 totalBets;
        mapping(address => uint256) bets;
    }

    Outcome public outcomeA;
    Outcome public outcomeB;

    IERC20 public usdcToken;

    event BetPlaced(address indexed bettor, string outcome, uint256 amount);
    event MarketResolved(string correctOutcome);
    event WinningsWithdrawn(address indexed user, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyOracle() {
        require(msg.sender == oracleAddress, "Unauthorized oracle");
        _;
    }

    modifier marketNotResolved() {
        require(!marketResolved, "Market already resolved");
        _;
    }

    constructor(address _usdcTokenAddress, address _oracleAddress, string memory _question, string memory _outcomeA, string memory _outcomeB) {
        admin = msg.sender;
        usdcToken = IERC20(_usdcTokenAddress);
        oracleAddress = _oracleAddress;
        marketQuestion = _question;
        outcomeA.name = _outcomeA;
        outcomeB.name = _outcomeB;
    }

    function placeBet(string memory outcomeName, uint256 amount) external marketNotResolved {
        require(amount > 0, "Bet amount must be greater than zero");
        require(keccak256(bytes(outcomeName)) == keccak256(bytes(outcomeA.name)) || keccak256(bytes(outcomeName)) == keccak256(bytes(outcomeB.name)), "Invalid outcome name");

        usdcToken.transferFrom(msg.sender, address(this), amount);

        if (keccak256(bytes(outcomeName)) == keccak256(bytes(outcomeA.name))) {
            outcomeA.bets[msg.sender] += amount;
            outcomeA.totalBets += amount;
        } else {
            outcomeB.bets[msg.sender] += amount;
            outcomeB.totalBets += amount;
        }

        emit BetPlaced(msg.sender, outcomeName, amount);
    }

    // Oracle callback function to resolve the market
    function oracleCallback(string memory _correctOutcome) external onlyOracle marketNotResolved {
        require(keccak256(bytes(_correctOutcome)) == keccak256(bytes(outcomeA.name)) || keccak256(bytes(_correctOutcome)) == keccak256(bytes(outcomeB.name)), "Invalid outcome name");

        correctOutcome = _correctOutcome;
        marketResolved = true;

        emit MarketResolved(_correctOutcome);
    }

    function withdrawWinnings() external {
        require(marketResolved, "Market not resolved yet");
        uint256 winnings;

        if (keccak256(bytes(correctOutcome)) == keccak256(bytes(outcomeA.name))) {
            require(outcomeA.bets[msg.sender] > 0, "No bets placed on the winning outcome");
            winnings = calculateWinnings(outcomeA.bets[msg.sender], outcomeA.totalBets, outcomeB.totalBets);
            outcomeA.bets[msg.sender] = 0;
        } else {
            require(outcomeB.bets[msg.sender] > 0, "No bets placed on the winning outcome");
            winnings = calculateWinnings(outcomeB.bets[msg.sender], outcomeB.totalBets, outcomeA.totalBets);
            outcomeB.bets[msg.sender] = 0;
        }

        usdcToken.transfer(msg.sender, winnings);
        emit WinningsWithdrawn(msg.sender, winnings);
    }

    function calculateWinnings(uint256 userBet, uint256 totalWinnerBets, uint256 totalLoserBets) internal pure returns (uint256) {
        return (userBet * totalLoserBets) / totalWinnerBets;
    }

    // Function for encoding the callback, for oracle registration
    function getEncodedCallback() public pure returns (bytes memory) {
        return abi.encodeWithSignature("oracleCallback(string)");
    }

    function getContractBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }

    // Admin can update oracle address 
    function setOracleAddress(address _newOracle) external onlyAdmin {
        oracleAddress = _newOracle;
    }
}
