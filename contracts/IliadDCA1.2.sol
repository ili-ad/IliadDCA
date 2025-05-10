// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title IliadDCA
 * @notice ERC721 Digital Certificate of Authenticity (DCA) contract with primary and backup URIs and failover capabilities.
 */
contract IliadDCA is Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    //Variables 
    /// @notice UNIX timestamp when the DCA contract will switch to using the backup URI.
    /// @dev Only updated via `setSwitchDate`.
    uint256 public switchDate;

    /// @notice Primary base URI for token metadata.
    /// @dev Used by `tokenURI()` when the current timestamp is before `switchDate`.
    string private primaryBaseURI;

    /// @notice Backup base URI for token metadata.
    /// @dev Used by `tokenURI()` when the current timestamp is after `switchDate`.
    string private backupBaseURI;

    /// @notice Sequential counter for assigning new token IDs.
    /// @dev Starts at zero and is incremented on each call to `mint()`.
    uint256 private _tokenIdCounter;

    /// @notice Custom path segment for each token’s metadata URI.
    /// @dev Appended to the active base URI within `tokenURI()`.
    mapping(uint256 => string) private _tokenPath;

    /// @notice Lock status for each token (true = locked).
    /// @dev A locked token cannot be transferred until `unlockToken()` is called.
    mapping(uint256 => bool) private _tokenLocked;

    /// @notice Primary contract‐level metadata URI.
    /// @dev Returned by `contractURI()` if set; otherwise fallback to `backupContractURI`.
    string private baseContractURI;

    /// @notice Backup contract‐level metadata URI.
    /// @dev Used by `contractURI()` when `baseContractURI` is empty.
    string private backupContractURI;


    // Events
    /// @notice Emitted when a new DCA token is minted.
    /// @param to The address receiving the minted token.
    /// @param tokenId The ID of the token that was minted.
    /// @param tokenPath The metadata path assigned to the new token.
    event Minted(
        address indexed to,
        uint256 indexed tokenId,
        string tokenPath
    );

    /// @notice Emitted whenever the primary base URI is updated.
    /// @param newBaseURI The new primary base URI string.
    event BaseURISet(string newBaseURI);

    /// @notice Emitted whenever the backup base URI is updated.
    /// @param newBackupURI The new backup base URI string.
    event BackupURISet(string newBackupURI);

    /// @notice Emitted whenever the primary contract metadata URI is changed.
    /// @param newURI The new primary contract-level metadata URI.
    event ContractURISet(string newURI);

    /// @notice Emitted whenever the backup contract metadata URI is changed.
    /// @param newBackupURI The new backup contract-level metadata URI.
    event BackupContractURISet(string newBackupURI);

    /// @notice Emitted when the switch date for primary→backup URI is updated.
    /// @param newSwitchDate UNIX timestamp when the backup URI will become active.
    event SwitchDateUpdated(uint256 newSwitchDate);

    /// @notice Emitted when an existing token is burned and removed.
    /// @param tokenId The ID of the token that was burned.
    event TokenBurned(uint256 indexed tokenId);

    /// @notice Emitted when a token is locked, preventing transfers.
    /// @param tokenId The ID of the token that was locked.
    event Locked(uint256 tokenId);

    /// @notice Emitted when a previously locked token is unlocked, allowing transfers again.
    /// @param tokenId The ID of the token that was unlocked.
    event Unlocked(uint256 tokenId);






    /**
     * @notice Initializes the DCA contract with primary and backup URIs and a switch date.
     * @param initialBaseURI       The initial primary base URI for token metadata.
     * @param initialBackupBaseURI The initial backup base URI used after switch date.
     * @param initialSwitchDate    UNIX timestamp at which the contract will begin using the backup URI.
     */
    function initialize(string memory initialBaseURI, string memory initialBackupBaseURI, uint256 initialSwitchDate) public initializer {
        __ERC721_init("ili.ad DCA", "IDCA");
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        primaryBaseURI = initialBaseURI;
        backupBaseURI = initialBackupBaseURI;
        switchDate = initialSwitchDate;
        _tokenIdCounter = 0;

        emit BaseURISet(initialBaseURI);
        emit BackupURISet(initialBackupBaseURI);
        emit SwitchDateUpdated(initialSwitchDate);
    }




    /**
     * @notice Mints a new DCA token to the given address with a custom URI path.
     * @param to        Recipient address of the minted token.
     * @param tokenPath Path segment appended to the active base URI for this token.
     */
    function mint(address to, string memory tokenPath) external onlyOwner {
        uint256 tokenId = ++_tokenIdCounter;
        _safeMint(to, tokenId);
        _tokenPath[tokenId] = tokenPath;

        _tokenLocked[tokenId] = false;
        emit Minted(to, tokenId, tokenPath);
    }

    /**
     * @notice Locks a token to prevent transfers until it is explicitly unlocked by the owner.
     * @param tokenId  The ID of the token to lock.
     */
    function lockToken(uint256 tokenId) external onlyOwner {
        require(ownerOf(tokenId) != address(0), "Lock nonexistent token");
        _tokenLocked[tokenId] = true;
        emit Locked(tokenId);
    }

    /**
     * @notice Unlocks a previously locked token, re-enabling transfers.
     * @param tokenId  The ID of the token to unlock.
     */
    function unlockToken(uint256 tokenId) external onlyOwner {
        require(ownerOf(tokenId) != address(0), "Unlock nonexistent token");
        _tokenLocked[tokenId] = false;
        emit Unlocked(tokenId);
    }

    /**
     * @notice Check if a specific token is currently locked.
     * @param tokenId Token ID to check lock status.
     * @return Boolean indicating locked (true) or unlocked (false) state.
     */
    function isLocked(uint256 tokenId) external view returns (bool) {
        return _tokenLocked[tokenId];
    }

    /**
     * @notice [internal] Enforces lock state on token transfers.
     * @dev Overrides ERC721Upgradeable’s _update to revert if the token is locked.
     * @param to       Address receiving the token.
     * @param tokenId  The ID of the token being transferred.
     * @param auth     Address initiating the transfer (owner or approved).
     * @return         The address authorized to receive the token (from parent).
     */
    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
        require(!_tokenLocked[tokenId], "Token is locked");
        return super._update(to, tokenId, auth);
    }

    /**
     * @notice Burns (permanently destroys) a token and clears its custom path.
     * @param tokenId  The ID of the token to burn.
     */
    function burn(uint256 tokenId) external onlyOwner {
        require(ownerOf(tokenId) != address(0), "Cannot burn nonexistent token");
        _burn(tokenId);
        delete _tokenPath[tokenId];

        emit TokenBurned(tokenId);
    }

    /**
     * @notice Updates the primary base URI used for token metadata.
     * @param newPrimaryBaseURI  The new primary base URI string.
     */
    function setPrimaryBaseURI(string memory newPrimaryBaseURI) external onlyOwner {
        primaryBaseURI = newPrimaryBaseURI;
        emit BaseURISet(newPrimaryBaseURI);
    }

    /**
     * @notice Updates the backup base URI used after the switch date.
     * @param newBackupBaseURI   The new backup base URI string.
     */
    function setBackupBaseURI(string memory newBackupBaseURI) external onlyOwner {
        backupBaseURI = newBackupBaseURI;
        emit BackupURISet(newBackupBaseURI);
    }

    /**
     * @notice Sets a new timestamp at which the backup URI becomes active.
     * @param newSwitchDate      UNIX timestamp (must be in the future).
     */
    function setSwitchDate(uint256 newSwitchDate) external onlyOwner {
        require(newSwitchDate > block.timestamp, "Switch date must be in the future");
        switchDate = newSwitchDate;
        emit SwitchDateUpdated(newSwitchDate);
    }

    /**
     * @notice Returns the current primary base URI for tokens.
     * @return                   The primary base URI string.
     */
    function getPrimaryBaseURI() external view returns (string memory) {
        return primaryBaseURI;
    }

    /**
     * @notice Returns the current backup base URI for tokens.
     * @return                   The backup base URI string.
     */
    function getBackupBaseURI() external view returns (string memory) {
        return backupBaseURI;
    }

    /**
     * @notice Returns the active contract-level metadata URI.
     * @dev If `baseContractURI` is non-empty, returns that; otherwise returns `backupContractURI`.
     * @return                   The contract metadata URI.
     */
    function contractURI() public view returns (string memory) {
        if (bytes(baseContractURI).length > 0) {
            return baseContractURI;
        } else {
            return backupContractURI;
        }
    }


    /**
     * @notice Sets or updates the primary contract-level metadata URI.
     * @param newURI            The new primary contract metadata URI string.
     */
    function setContractURI(string calldata newURI) external onlyOwner {
        baseContractURI = newURI;
        emit ContractURISet(newURI);
    }


    /**
     * @notice Sets or updates the backup contract-level metadata URI.
     * @param newBackupURI      The new backup contract metadata URI string.
     */
    function setBackupContractURI(string calldata newBackupURI) external onlyOwner {
        backupContractURI = newBackupURI;
        emit BackupContractURISet(newBackupURI);
    }



    /**
     * @notice Returns the full token URI for a given token ID, switching between primary and backup URIs based on the current timestamp.
     * @param tokenId          The ID of the token whose URI is requested.
     * @return                 The assembled token URI string.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "URI query for nonexistent token");
        string memory activeBaseURI = block.timestamp > switchDate ? backupBaseURI : primaryBaseURI;
        return string(abi.encodePacked(activeBaseURI, _tokenPath[tokenId]));
    }

    /**
     * @notice [internal] Authorizes a UUPS upgrade to a new implementation.
     * @dev Overrides UUPSUpgradeable authorization and restricts upgrades to the contract owner.
     * @param newImplementation The address of the new implementation contract.
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // Storage gap for future-proofing upgrades
    uint256[47] private __gap;
}
