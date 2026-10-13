// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Combined Authorization and Ether Transfer Contract
/// @notice This contract merges the Auth and SendEther contracts from Lab 7.
///         Only the owner can send Ether on behalf of the contract.
contract AuthSendEther {

    // ─────────────────────────────────────────────
    //  AUTHORIZATION (from Lab7-eg1.sol)
    // ─────────────────────────────────────────────

    address public owner;

    /// @dev Sets the deployer as the initial owner.
    constructor() {
        owner = msg.sender;
    }

    /// @dev Restricts access to owner-only functions.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    /// @notice Transfers ownership to a new address.
    /// @param _newOwner The address of the new owner.
    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }

    // ─────────────────────────────────────────────
    //  RECEIVE ETHER (from Lab7-eg3.sol)
    // ─────────────────────────────────────────────

    /// @notice Allows the contract to receive Ether directly.
    receive() external payable {}

    /// @notice Fallback for calls with data.
    fallback() external payable {}

    /// @notice Returns the contract's current Ether balance.
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // ─────────────────────────────────────────────
    //  SEND ETHER — OWNER ONLY (from Lab7-eg3.sol)
    // ─────────────────────────────────────────────

    /// @notice Sends Ether using transfer (not recommended, kept for reference).
    /// @param _to Recipient address.
    function sendViaTransfer(address payable _to) external payable onlyOwner {
        _to.transfer(msg.value);
    }

    /// @notice Sends Ether using send (not recommended, kept for reference).
    /// @param _to Recipient address.
    function sendViaSend(address payable _to) external payable onlyOwner {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether via send");
    }

    /// @notice Sends Ether using call (recommended method).
    /// @param _to Recipient address.
    function sendViaCall(address payable _to) external payable onlyOwner {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether via call");
    }
}

