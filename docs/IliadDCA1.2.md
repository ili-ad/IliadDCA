# Solidity API

## IliadDCA

ERC721 Digital Certificate of Authenticity (DCA) contract with primary and backup URIs and failover capabilities.

## Functions

### initialize

```solidity
function initialize(string initialBaseURI, string initialBackupBaseURI, uint256 initialSwitchDate) public
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### mint

```solidity
function mint(address to, string tokenPath) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### lockToken

```solidity
function lockToken(uint256 tokenId) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### unlockToken

```solidity
function unlockToken(uint256 tokenId) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### isLocked

```solidity
function isLocked(uint256 tokenId) external view returns (bool)
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### _update

```solidity
function _update(address to, uint256 tokenId, address auth) internal virtual returns (address)
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### burn

```solidity
function burn(uint256 tokenId) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setPrimaryBaseURI

```solidity
function setPrimaryBaseURI(string newPrimaryBaseURI) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setBackupBaseURI

```solidity
function setBackupBaseURI(string newBackupBaseURI) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setSwitchDate

```solidity
function setSwitchDate(uint256 newSwitchDate) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### getPrimaryBaseURI

```solidity
function getPrimaryBaseURI() external view returns (string)
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### getBackupBaseURI

```solidity
function getBackupBaseURI() external view returns (string)
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### contractURI

```solidity
function contractURI() public view returns (string)
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### setContractURI

```solidity
function setContractURI(string newURI) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### setBackupContractURI

```solidity
function setBackupContractURI(string newBackupURI) external
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `view`

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

#### Returns

| Type             | Description                         |
| ---------------- | ----------------------------------- |
| `—` | — |

> **Mutability:** `nonpayable`

