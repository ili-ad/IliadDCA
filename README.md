# IliadDCA

Upgradeable ERC-721 ‘Digital Certificate of Authenticity’ with automatic fail-over from primary to backup metadata URIs, full Hardhat test suite, and Markdoc-based API docs.

---

## Why Did I Do This?

When I started ili.ad, I initially tried making everything myself in-house. I quickly learned that operating as a one-man studio in the most expensive city in North America is barely sustainable. My approach also reflects my background as an architect, where collaboration and delegation are integral to creating complex projects. Delegation introduces challenges, particularly ensuring each product meets my precise specifications and standards. Minting one of these digital certificates explicitly confirms my approval, verifying the authenticity and quality of the object. Historically, architects have marked their work with recognizable signatures, like Frank Lloyd Wright's red tiles or keystones bearing the marks of their creators. This digital certificate serves as a contemporary equivalent.

## What Does This Contract Do?

This **Digital Certificate of Authenticity (DCA)** permanently establishes the authenticity, provenance, and ownership of your purchased art or design object, securely recorded on the Ethereum blockchain.

In simple terms, this digital certificate acts as a **tamper-proof proof of authenticity**—like a digital fingerprint or a permanent record—ensuring the object you purchased is genuinely produced, limited, and traceable to its origin.

## What Does This Give the Buyer?

When you purchase an object with this digital certificate, you receive:

- **Immutable Proof of Authenticity:**  
  A permanent, blockchain-backed record proving your object is authentic and officially recognized by the creator or issuer.

- **Secure Provenance:**  
  The full, verifiable history of the object’s ownership and origin remains permanently accessible, increasing its value and credibility over time.

- **Transparent Ownership:**  
  Your ownership of the certificate—and by extension, the authentic object—is clearly documented and securely protected.

- **Controlled Transferability:**  
  Certificates can be securely transferred or locked to protect authenticity and provenance, preventing unauthorized or unintended transfers.

- **Permanence and Longevity:**  
  A built-in failover mechanism ensures that your digital certificate remains valid and accessible long-term, even in the unlikely event that the original hosting platform changes.

## How Does This Differ from a Typical NFT?

Unlike common NFTs, which primarily trade speculative digital assets, this DCA establishes a permanent, trustworthy connection between a **physical art or design object** and its **digital record of authenticity and provenance**. The goal is not speculative trading, but credibility, trust, and enduring value.

We leverage the flexible tooling of the ERC-721 protocol, widely used for NFTs, to serve a distinctly different purpose. We've removed any financial incentive for trading DCAs independently of their physical objects by contractually requiring a 100% commission. While you can easily view and manage certificates using platforms like OpenSea and store them in wallets such as MetaMask or other NFT-compatible wallets, our intention is clear: we fully support trading the physical object, but the digital certificate itself is not meant to take on an independent speculative life: sell the object for value; transfer the certificate as a rider.

## Key Contract Features (Transparent, for Verification):

- **Minting** (issuer can create new, verified certificates)
- **Burning** (issuer can revoke or replace lost or compromised certificates)
- **Locking Tokens** (issuer can control transferability to protect authenticity)
- **Dynamic URI Failover** (ensuring long-term availability of certificate metadata)

You can verify and review the complete, open-source smart contract here:


### Design & Intent (Why Blockchain?):

This contract provides something physical certificates cannot—complete transparency, immutability, and verifiable authenticity on a public blockchain. It's a simple but sophisticated solution, making your investment more secure, credible, and valuable.

# &nbsp;
# Solidity API

## IliadDCA

ERC721 Digital Certificate of Authenticity (DCA) contract with primary and backup URIs and failover capabilities.

## State Variables

| Name              | Type       | Description                                         |
| ----------------- | ---------- | --------------------------------------------------- |
| `switchDate`      | `uint256`  | UNIX timestamp when the DCA switches to the backup URI. |
| `primaryBaseURI`  | `string`   | Base URI before the switch date.                    |
| `backupBaseURI`   | `string`   | Base URI after the switch date.                     |
| `_tokenIdCounter` | `uint256`  | Sequential counter for new token IDs.               |
| `_tokenPath`      | `uint256→string` | Custom path segment for each token’s metadata. |
| `_tokenLocked`    | `uint256→bool`   | Lock status per token; locked tokens cannot transfer. |
| `baseContractURI` | `string`   | Primary contract-level metadata URI.                |
| `backupContractURI`| `string`  | Fallback contract-level metadata URI.               |

## Events

| Event                | Parameters                                    | Description                                    |
| -------------------- | --------------------------------------------- | ---------------------------------------------- |
| `Minted`             | `to: address`, `tokenId: uint256`, `tokenPath: string` | Emitted when a new DCA token is minted.        |
| `BaseURISet`         | `newBaseURI: string`                          | Emitted when the primary base URI is updated.  |
| `BackupURISet`       | `newBackupBaseURI: string`                    | Emitted when the backup base URI is updated.   |
| `ContractURISet`     | `newURI: string`                              | Emitted when the primary contract URI is set.  |
| `BackupContractURISet`| `newBackupURI: string`                       | Emitted when the backup contract URI is set.   |
| `SwitchDateUpdated`  | `newSwitchDate: uint256`                      | Emitted when the failover switch date changes. |
| `TokenBurned`        | `tokenId: uint256`                            | Emitted when a token is burned.                |
| `Locked`             | `tokenId: uint256`                            | Emitted when a token is locked.                |
| `Unlocked`           | `tokenId: uint256`                            | Emitted when a token is unlocked.              |


## Functions

### initialize

```solidity
function initialize(string initialBaseURI, string initialBackupBaseURI, uint256 initialSwitchDate) public
```

Initializes the DCA contract with primary and backup URIs and a switch date.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| initialBaseURI | string | The initial primary base URI for token metadata. |
| initialBackupBaseURI | string | The initial backup base URI used after switch date. |
| initialSwitchDate | uint256 | UNIX timestamp at which the contract will begin using the backup URI. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### mint

```solidity
function mint(address to, string tokenPath) external
```

Mints a new DCA token to the given address with a custom URI path.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | Recipient address of the minted token. |
| tokenPath | string | Path segment appended to the active base URI for this token. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### lockToken

```solidity
function lockToken(uint256 tokenId) external
```

Locks a token to prevent transfers until it is explicitly unlocked by the owner.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to lock. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### unlockToken

```solidity
function unlockToken(uint256 tokenId) external
```

Unlocks a previously locked token, re-enabling transfers.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to unlock. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### isLocked

```solidity
function isLocked(uint256 tokenId) external view returns (bool)
```

Check if a specific token is currently locked.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | Token ID to check lock status. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | Boolean indicating locked (true) or unlocked (false) state. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### _update

```solidity
function _update(address to, uint256 tokenId, address auth) internal virtual returns (address)
```

[internal] Enforces lock state on token transfers.

_Overrides ERC721Upgradeable’s _update to revert if the token is locked._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | Address receiving the token. |
| tokenId | uint256 | The ID of the token being transferred. |
| auth | address | Address initiating the transfer (owner or approved). |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The address authorized to receive the token (from parent). |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### burn

```solidity
function burn(uint256 tokenId) external
```

Burns (permanently destroys) a token and clears its custom path.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token to burn. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setPrimaryBaseURI

```solidity
function setPrimaryBaseURI(string newPrimaryBaseURI) external
```

Updates the primary base URI used for token metadata.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newPrimaryBaseURI | string | The new primary base URI string. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setBackupBaseURI

```solidity
function setBackupBaseURI(string newBackupBaseURI) external
```

Updates the backup base URI used after the switch date.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newBackupBaseURI | string | The new backup base URI string. |

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setSwitchDate

```solidity
function setSwitchDate(uint256 newSwitchDate) external
```

Sets a new timestamp at which the backup URI becomes active.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newSwitchDate | uint256 | UNIX timestamp (must be in the future). |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### getPrimaryBaseURI

```solidity
function getPrimaryBaseURI() external view returns (string)
```

Returns the current primary base URI for tokens.


#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The primary base URI string. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### getBackupBaseURI

```solidity
function getBackupBaseURI() external view returns (string)
```

Returns the current backup base URI for tokens.


#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The backup base URI string. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### contractURI

```solidity
function contractURI() public view returns (string)
```

Returns the active contract-level metadata URI.

_If `baseContractURI` is non-empty, returns that; otherwise returns `backupContractURI`._


#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The contract metadata URI. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### setContractURI

```solidity
function setContractURI(string newURI) external
```

Sets or updates the primary contract-level metadata URI.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newURI | string | The new primary contract metadata URI string. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setBackupContractURI

```solidity
function setBackupContractURI(string newBackupURI) external
```

Sets or updates the backup contract-level metadata URI.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newBackupURI | string | The new backup contract metadata URI string. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

Returns the full token URI for a given token ID, switching between primary and backup URIs based on the current timestamp.


#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token whose URI is requested. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | The assembled token URI string. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

[internal] Authorizes a UUPS upgrade to a new implementation.

_Overrides UUPSUpgradeable authorization and restricts upgrades to the contract owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newImplementation | address | The address of the new implementation contract. |


#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`


## Contract Code
Please see contracts folder here.

