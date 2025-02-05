// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./DataReachToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title DataReachICO
 * @dev A smart contract for conducting an ICO (Initial Coin Offering) for DatareachCoin tokens.
 */
contract DataReachICO is Ownable, Pausable {
    struct UserInfo {
        uint256 invested; // Amount of BNB invested by the user
        uint256 received; // Amount of DatareachCoin tokens received by the user
        bool isblock; // Whether the user is blocked from participating
    }

    DataReachToken public token; // The token being sold
    uint256 public tokenRate; // Number of BNB per Datareach Coin
    uint256 public startTime; // Timestamp when the ICO starts
    uint256 public endTime; // Timestamp when the ICO ends
    uint256 public maxAmount; // Maximum amount of BNB that can be invested
    uint256 public minAmount; // Minimum amount of BNB that can be invested
    uint256 public raisedBNB; // Total amount of BNB raised
    uint256 public tokenSold; // Total amount of tokens sold
    address public collectorWallet; // Address where funds are collected

    uint8 private constant DECIMALS = 18; // Decimals for token calculations
    mapping(address => UserInfo) public userInfos; // Mapping of user addresses to UserInfo

    event StartTimeUpdated(uint256 oldTimeStamp, uint256 newTimeStamp);
    event EndTimeUpdated(uint256 oldTimeStamp, uint256 newTimeStamp);
    event TokenRateUpdated(uint256 oldTokenRate, uint256 newTokenRate);
    event MaxAmountUpdated(uint256 oldAmount, uint256 newAmount);
    event MinAmountUpdated(uint256 oldAmount, uint256 newAmount);
    event Purchased(address buyer, uint256 amount);
    event BulkTransferCompleted(uint256 totalAmount);

    /**
     * @dev Constructor function
     * @param _token Address of the Datareach token being sold
     * @param _tokenRate Number of BNB per Datareach Coin
     * @param _startTime Timestamp when the ICO starts
     * @param _endTime Timestamp when the ICO ends
     * @param _maxAmount Maximum amount of BNB that can be invested
     * @param _minAmount Minimum amount of BNB that can be invested
     * @param _collectorWallet Address where funds are collected
     * @param _owner Owner of the contract
     */
    constructor(
        address _token,
        uint256 _tokenRate,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _maxAmount,
        uint256 _minAmount,
        address _collectorWallet,
        address _owner
    ) Ownable(_owner) {
        require(_token != address(0), "Invalid Token Address");
        require(_tokenRate > 0, "Invalid Token Rate");
        require(_endTime > _startTime, "Time invalid");
        require(_startTime >= _getCurrentTime(), "StartTime invalid ");
        require(_maxAmount > _minAmount, "Invalid Max Amount");
        require(_minAmount > 0, "Invalid Min Amount");
        require(
            _collectorWallet != address(0),
            "Invalid CollectorWallet Address"
        );
        token = DataReachToken(_token);
        tokenRate = _tokenRate;
        startTime = _startTime;
        endTime = _endTime;
        maxAmount = _maxAmount;
        minAmount = _minAmount;
        collectorWallet = _collectorWallet;
    }

    /**
     * @dev Fallback function to receive BNB
     */
    receive() external payable {
        buyTokens();
    }

    /**
     * @dev Fallback function to receive BNB
     */
    fallback() external payable {
        buyTokens();
    }

    /**
     * @dev Pauses the ICO
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses the ICO
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Updates the start time of the ICO
     * @param _startTime New start time
     */
    function updateStartTime(uint256 _startTime) external onlyOwner {
        require(startTime > _getCurrentTime(), "ICO Already Started");
        require(_startTime > _getCurrentTime(), "StartTime Invalid");
        require(_startTime < endTime, "StartTime Invalid");
        uint256 oldTimeStamp = startTime;
        startTime = _startTime;
        emit StartTimeUpdated(oldTimeStamp, startTime);
    }

    /**
     * @dev Updates the end time of the ICO
     * @param _endTime New end time
     */
    function updateEndTime(uint256 _endTime) external onlyOwner {
        require(endTime > _getCurrentTime(), "ICO Already Finished");
        require(_endTime > _getCurrentTime(), "EndTime Invalid");
        require(_endTime > startTime, "EndTime Invalid");
        uint256 oldTimeStamp = endTime;
        endTime = _endTime;
        emit EndTimeUpdated(oldTimeStamp, endTime);
    }

    /**
     * @dev Updates the token rate
     * @param _tokenRate New token rate
     */
    function updateTokenRate(uint256 _tokenRate) external onlyOwner {
        require(_tokenRate > 0, "Invalid Token Rate");
        uint256 oldTokenRate = tokenRate;
        tokenRate = _tokenRate;
        emit TokenRateUpdated(oldTokenRate, tokenRate);
    }

    /**
     * @dev Updates the maximum investment amount
     * @param _maxAmount New maximum amount
     */
    function updateMaxAmount(uint256 _maxAmount) external onlyOwner {
        require(_maxAmount > minAmount, "Invalid Max Amount");
        uint256 oldMaxAmount = maxAmount;
        maxAmount = _maxAmount;
        emit MaxAmountUpdated(oldMaxAmount, maxAmount);
    }

    /**
     * @dev Updates the minimum investment amount
     * @param _minAmount New minimum amount
     */
    function updateMinAmount(uint256 _minAmount) external onlyOwner {
        require(_minAmount > 0, "Invalid Min Amount");
        require(maxAmount > _minAmount, "Invalid Min Amount");
        uint256 oldMinAmount = minAmount;
        minAmount = _minAmount;
        emit MinAmountUpdated(oldMinAmount, minAmount);
    }

    /**
     * @dev Updates the collector wallet address
     * @param _collectorWallet New collector wallet address
     */
    function updateCollectorWallet(
        address _collectorWallet
    ) external onlyOwner {
        require(
            _collectorWallet != address(0),
            "Invalid CollectorWallet Address"
        );
        collectorWallet = _collectorWallet;
    }

    /**
     * @dev Blocks a user from participating in the ICO
     * @param _user Address of the user to be blocked
     */
    function blockUser(address _user) external onlyOwner {
        userInfos[_user].isblock = true;
    }

    /**
     * @dev Allows a user to purchase tokens during the ICO
     */
    function buyTokens() public payable whenNotPaused {
        require(_getCurrentTime() >= startTime, "ICO not Started");
        require(_getCurrentTime() <= endTime, "ICO Already Finished");
        require(!userInfos[msg.sender].isblock, "You Are Blocked");

        uint256 weiAmount = msg.value;

        require(weiAmount >= minAmount, "Minimum Amount Not Reached");
        require(
            userInfos[msg.sender].invested + weiAmount <= maxAmount,
            "Maximum Amount Reached"
        );

        uint256 tokenAmount = (weiAmount * (10 ** DECIMALS)) / tokenRate;

        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "Insufficient Token Balance In ICO Contract"
        );

        userInfos[msg.sender].invested += weiAmount;
        userInfos[msg.sender].received += tokenAmount;

        token.transfer(msg.sender, tokenAmount);
        payable(collectorWallet).transfer(msg.value);
        tokenSold += tokenAmount;
        raisedBNB += weiAmount;

        emit Purchased(msg.sender, tokenAmount);
    }

    /**
     * @dev Allows emergency withdrawal of remaining tokens when paused
     * @param _to Address to which remaining tokens are withdrawn
     */
    function emergencyWithdrawal(address _to) external onlyOwner whenPaused {
        uint256 remainingTokens = token.balanceOf(address(this));
        require(remainingTokens > 0, "Insufficient Token Balance");

        token.transfer(_to, remainingTokens);
    }

    /**
     * @dev Allows withdrawal of unsold tokens after the ICO ends
     * @param _to Address to which unsold tokens are withdrawn
     */
    function withdrawUnsoldToken(address _to) external onlyOwner {
        require(endTime < _getCurrentTime(), "ICO Not Finished");
        uint256 remainingTokens = token.balanceOf(address(this));
        require(remainingTokens > 0, "Insufficient Token Balance");

        token.transfer(_to, remainingTokens);
    }

    /**
     * @dev Allows bulk transfer of tokens to multiple recipients
     * @param _recipients Array of recipient addresses
     * @param _values Array of token amounts corresponding to each recipient
     */
    function bulkTransfer(
        address[] calldata _recipients,
        uint256[] calldata _values
    ) external onlyOwner whenNotPaused {
        require(_recipients.length == _values.length, "Arrays length mismatch");

        uint256 totalAmount = 0;

        for (uint256 i = 0; i < _recipients.length; i++) {
            token.transfer(_recipients[i], _values[i]);
            totalAmount += _values[i];
        }

        emit BulkTransferCompleted(totalAmount);
    }

    /**
     * @dev Gets the current timestamp
     * @return Current timestamp
     */
    function _getCurrentTime() private view returns (uint128) {
        return uint128(block.timestamp);
    }
}
