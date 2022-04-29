//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Gambling is VRFConsumerBase {

    // addressToBalance mapping stores the balance of each player
    mapping (address=>uint) public addressToBalance;
    address private immutable owner;
    /// @dev events to emit whenever there is a state change so that the front end can update
    event Deposit(address indexed player, uint amount);
    event Withdraw(address indexed player, uint amount);
    event RequestedRandomness (bytes32 indexed requestId);
    event GameWon (address indexed player, uint playerBet, uint playerNumber, uint randomNumber );
    event GameLost (address indexed player, uint playerBet, uint playerNumber, uint randomNumber );
    uint fee;
    bytes32 keyHash;
    uint private userBet;
    uint private userNumber;
    address player;

    /*chain link details for mumbai testnet 
    The VRF Coordinator for Mumbai Testnet is 0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
The address of the LINK token on the Mumbai Testnet is 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
The KeyHash for Mumbai Testnet is 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
The fee for making a VRF request on the Mumbai Testnet is 100000000000000 (0.0001 LINK)
*/


    /// @dev contract deployer is the owner of the contract
    constructor () public VRFConsumerBase(0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, 0x326C977E6efc84E512bB9C30f76E30c160eD06FB) {
        owner = msg.sender;
        fee = 0.0001 * 10**18;
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
    }


    /// @dev this function receives money from the users and updates the addressToBalance mapping.
    function deposit() external payable {
        require(msg.value >0, "You must deposit a positive amount");
        addressToBalance[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    ///@dev user can withdraw money from the contract if he has enough balance. Balance will be updated in the addressToBalance mapping.
    function withdraw(uint amount) external {
        require(amount>0, "You must withdraw a positive amount");
        require(addressToBalance[msg.sender] >= amount, "You don't have enough money to withdraw");
        addressToBalance[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "error occured while trying to withdraw");
        emit Withdraw(msg.sender, amount);
    }

    function play(uint _userNumber, uint bet) external payable {
        require(userNumber < 10, "userNumber should be between 0 and 9");
        require(bet>0, "bet should be greater than 0");
        require(addressToBalance[msg.sender] >= bet, "You don't have enough money to place this bet");
        addressToBalance[msg.sender] -= bet;
        userBet = bet; 
        userNumber = _userNumber;
        player = msg.sender;
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        bytes32 requestId = requestRandomness(keyHash, fee);
        emit RequestedRandomness(requestId);
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
        require(_randomness>0, "random not defines");
        uint randomNumber = _randomness % 10;
        if (randomNumber == userNumber) {
            addressToBalance[player] += userBet * 2;
            emit GameWon (player, userBet, userNumber, randomNumber);

        } else {
            emit GameLost (player, userBet, userNumber, randomNumber);
        }
    }

}

