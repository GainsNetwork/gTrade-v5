// SPDX-License-Identifier: MIT
import './interfaces/TokenInterfaceV5.sol';
pragma solidity 0.8.7;

contract GFarmTokenMigration{

	address public immutable gov;
	TokenInterfaceV5 public immutable oldToken;
	TokenInterfaceV5 public newToken;

	constructor(address _gov, TokenInterfaceV5 _oldToken){
		oldToken = _oldToken;
		gov = _gov;
	}

	// Set token after contract deployed
	// => can give minting role to this contract when deploy new token
	function setNewToken(TokenInterfaceV5 _newToken) external{
		require(msg.sender == gov, "NOT_GOV");
		require(address(_newToken) != address(0), "ADDRESS_0");
		require(address(newToken) == address(0), "ALREADY_SET");
		newToken = _newToken;
	}

	// Send x amount of GFARM2 tokens and receive 1000x GNS tokens.
	function migrateToNewToken(uint _amount) external{
		require(oldToken.balanceOf(msg.sender) >= _amount, "BALANCE_TOO_LOW");
		oldToken.transferFrom(msg.sender, address(this), _amount);
		newToken.mint(msg.sender, _amount*1000);
	}
}