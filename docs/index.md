# Solidity API

## IliadDCO

_ERC721 Token with governance and metadata management._

### MINTER_ROLE

```solidity
bytes32 MINTER_ROLE
```

### PROPOSER_ROLE

```solidity
bytes32 PROPOSER_ROLE
```

### APPROVER_ROLE

```solidity
bytes32 APPROVER_ROLE
```

### METADATA_MANAGER_ROLE

```solidity
bytes32 METADATA_MANAGER_ROLE
```

### Proposal

_Structure to store proposal details._

```solidity
struct Proposal {
  string action;
  uint256 tokenId;
  bytes params;
  uint8 approvals;
  bool active;
  uint256 createdAt;
}
```

### quorumThresholds

```solidity
mapping(string => uint256) quorumThresholds
```

### defaultExpiry

```solidity
uint256 defaultExpiry
```

### ProposalCreated

```solidity
event ProposalCreated(bytes32 actionHash, string action, address proposer)
```

### ProposalApproved

```solidity
event ProposalApproved(bytes32 actionHash, address approver)
```

### ProposalRevoked

```solidity
event ProposalRevoked(bytes32 actionHash, address revoker)
```

### ProposalExecuted

```solidity
event ProposalExecuted(bytes32 actionHash, string action)
```

### ProposalExpired

```solidity
event ProposalExpired(bytes32 actionHash)
```

### ProposalReactivated

```solidity
event ProposalReactivated(bytes32 actionHash, address reactivator)
```

### ProposalArchived

```solidity
event ProposalArchived(bytes32 actionHash)
```

### TokenMetadataLocked

```solidity
event TokenMetadataLocked(uint256 tokenId)
```

### TokenMetadataUnlocked

```solidity
event TokenMetadataUnlocked(uint256 tokenId)
```

### RoleGranted

```solidity
event RoleGranted(bytes32 role, address account)
```

### RoleRevoked

```solidity
event RoleRevoked(bytes32 role, address account)
```

### TokenMinted

```solidity
event TokenMinted(address to, uint256 tokenId, string serial)
```

### TokenBurned

```solidity
event TokenBurned(uint256 tokenId, address burnedBy)
```

### TokenForceTransferred

```solidity
event TokenForceTransferred(uint256 tokenId, address from, address to)
```

### BaseURISet

```solidity
event BaseURISet(string newBaseURI)
```

### BaseURIUpdated

```solidity
event BaseURIUpdated(string oldBaseURI, string newBaseURI)
```

### constructor

```solidity
constructor(string _baseURI) public
```

_Constructor to initialize the contract with base URI and set up roles.
Also initializes quorum thresholds for supported actions._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _baseURI | string | The base URI for token metadata. |

### mint

```solidity
function mint(address to, string serial) public
```

Mint a new token with a unique serial number.

_Only accounts with MINTER_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The address to receive the newly minted token. |
| serial | string | A 6-character serial string, unique for each token. |

### proposeAction

```solidity
function proposeAction(string action, uint256 tokenId, bytes params, uint256 customExpiry) public
```

Create a governance proposal for an action.

_The caller must wait 1 day between proposals._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| action | string | The action name (e.g., "burnAndReissue", "forceTransfer"). |
| tokenId | uint256 | The tokenId to which the action applies (if applicable). |
| params | bytes | Encoded parameters for the action. |
| customExpiry | uint256 | Optional custom expiry duration in seconds. If zero, defaultExpiry is used. |

### approveProposal

```solidity
function approveProposal(bytes32 actionHash) public
```

Approve a governance proposal.

_Automatically handles expired proposals by cleaning them up._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to approve. |

### revokeApproval

```solidity
function revokeApproval(bytes32 actionHash) public
```

Revoke an approval for a governance proposal.

_Only approvers who have previously approved can revoke their approval._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to revoke approval from. |

### reactivateProposal

```solidity
function reactivateProposal(bytes32 actionHash) public
```

Reactivate an expired proposal.

_The proposal must have expired to be reactivated. Requires re-approval._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to reactivate. |

### archiveProposal

```solidity
function archiveProposal(bytes32 actionHash) public
```

Archive a stale proposal.

_Only APPROVER_ROLE can archive inactive proposals._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to archive. |

### cleanUpProposal

```solidity
function cleanUpProposal(bytes32 actionHash) public
```

Clean up a previously expired (and inactive) proposal.

_Only APPROVER_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to clean. |

### executeAction

```solidity
function executeAction(bytes32 actionHash) internal
```

_Execute a governance action based on the proposal._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to execute. |

### burnAndReissue

```solidity
function burnAndReissue(uint256 tokenId, address newOwner, string newSerial) internal
```

Burn and optionally reissue a token.

_Only called internally upon proposal execution._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to burn. |
| newOwner | address | The address to receive the reissued token. |
| newSerial | string | The new serial number for the reissued token. |

### forceTransfer

```solidity
function forceTransfer(uint256 tokenId, address newOwner) internal
```

Force transfer a token to a new owner.

_Only called internally upon proposal execution._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to transfer. |
| newOwner | address | The address to receive the token. |

### lockMetadata

```solidity
function lockMetadata(uint256 tokenId) public
```

Lock metadata for a token to prevent further modifications.

_Only accounts with METADATA_MANAGER_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to lock metadata for. |

### unlockMetadata

```solidity
function unlockMetadata(uint256 tokenId) public
```

Unlock metadata for a token to allow modifications.

_Only accounts with DEFAULT_ADMIN_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to unlock metadata for. |

### isMetadataLocked

```solidity
function isMetadataLocked(uint256 tokenId) public view returns (bool)
```

Check if metadata is locked for a given token.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The token ID to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | True if metadata is locked, false otherwise. |

### setActionExpiry

```solidity
function setActionExpiry(string action, uint256 duration) public
```

Set a custom expiry duration for a specific action.

_Only accounts with DEFAULT_ADMIN_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| action | string | The action name. |
| duration | uint256 | The new expiry duration in seconds. |

### getActionExpiry

```solidity
function getActionExpiry(string action) public view returns (uint256)
```

Get the expiry duration for a given action.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| action | string | The action name. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The expiry duration in seconds. |

### isQuorumReached

```solidity
function isQuorumReached(bytes32 actionHash) internal view returns (bool)
```

_Check if a quorum has been reached for a proposal._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | True if quorum is reached, false otherwise. |

### resetProposal

```solidity
function resetProposal(bytes32 actionHash) internal
```

_Reset a proposal by deleting it from storage._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal to reset. |

### constructTokenURI

```solidity
function constructTokenURI(string serial) public view returns (string)
```

Construct a token URI from base URI and serial.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| serial | string | The token's serial string. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The fully constructed token URI. |

### isProposalActive

```solidity
function isProposalActive(bytes32 actionHash) public view returns (bool)
```

Check if a proposal is currently active and not expired.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | True if active and within expiry period, false otherwise. |

### getProposalStatus

```solidity
function getProposalStatus(bytes32 actionHash) public view returns (string)
```

Get the textual status of a proposal.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | "Active", "Expired", or "Inactive". |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

Override the supportsInterface to resolve multiple inheritance.

_Overrides both ERC721URIStorage and AccessControl implementations._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| interfaceId | bytes4 | The interface identifier, as specified in ERC-165. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | True if the contract implements `interfaceId`. |

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal virtual
```

Override the _beforeTokenTransfer to match the base class signature.

_Overrides ERC721's _beforeTokenTransfer function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | The address transferring the token. |
| to | address | The address receiving the token. |
| tokenId | uint256 | The ID of the token being transferred. |
| batchSize | uint256 | The number of tokens being transferred. |

### _setTokenURI

```solidity
function _setTokenURI(uint256 tokenId, string _tokenURI) internal
```

Override the _setTokenURI to include metadata lock check.

_Prevents setting token URI if metadata is locked._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token. |
| _tokenURI | string | The new token URI to set. |

### getBaseURI

```solidity
function getBaseURI() public view returns (string)
```

Get the base URI set for the contract.

_Since baseURI is not exposed directly, this function can be used if needed._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The base URI string. |

### setBaseURI

```solidity
function setBaseURI(string _newBaseURI) public
```

Set a new base URI for the contract.

_Only accounts with DEFAULT_ADMIN_ROLE can call this function.
Ensures the new base URI ends with a trailing slash._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _newBaseURI | string | The new base URI to set. |

### _setBaseURI

```solidity
function _setBaseURI(string _newBaseURI) internal
```

_Internal function to set the base URI._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _newBaseURI | string | The new base URI to set. |

### addQuorumThreshold

```solidity
function addQuorumThreshold(string action, uint256 threshold) public
```

Add a new quorum threshold for a specific action.

_Only accounts with DEFAULT_ADMIN_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| action | string | The action name. |
| threshold | uint256 | The quorum threshold required for the action. |

### removeQuorumThreshold

```solidity
function removeQuorumThreshold(string action) public
```

Remove a quorum threshold for a specific action.

_Only accounts with DEFAULT_ADMIN_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| action | string | The action name. |

### getTotalMinted

```solidity
function getTotalMinted() public view returns (uint256)
```

Get the total number of minted tokens.

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The total minted tokens count. |

### getProposalDetails

```solidity
function getProposalDetails(bytes32 actionHash) public view returns (struct IliadDCO.Proposal)
```

Get details of a specific proposal.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| actionHash | bytes32 | The hash of the proposal. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct IliadDCO.Proposal | The Proposal struct containing all details. |

