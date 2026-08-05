# UmerNft 🖼️

A minimal, gas-conscious ERC-721 NFT contract built with [Foundry](https://book.getfoundry.sh/), featuring on-chain royalty support via **ERC-2981** and off-chain metadata pinned to IPFS using **Pinata**.

---

## 📖 Overview

`UmerNft` is a fixed-supply NFT collection where each token's metadata URI is set **at deployment time** rather than being derived from a base URI pattern. This gives full control over exactly which metadata maps to which token.

Key features:

- **ERC-721** standard NFT implementation (OpenZeppelin)
- **ERC-2981** on-chain royalty standard for marketplace-enforced creator royalties
- **Ownable** access control for administrative functions
- **Fixed max supply** (`MAX_SUPPLY = 3`) with mint-limit protection
- **Pre-set token URIs**, supplied as a constructor argument and mapped per token ID
- **Custom errors** instead of require strings, for lower gas costs and clearer revert reasons

---

## ⚙️ How It Works

1. At deployment, the contract is initialized with:
   - An array of metadata URIs (one per NFT, must be `>= MAX_SUPPLY`)
   - A royalty receiver address
   - A royalty fraction (used to calculate royalty amount on sales)
2. Users call `mintNft()` to mint the next available token in sequence.
3. Each minted token is permanently linked to one of the pre-supplied URIs via `tokenIdToTokenUri`.
4. Marketplaces supporting **ERC-2981** can query `royaltyInfo()` to automatically calculate and route creator royalties on secondary sales.

### Contract Errors

| Error | Thrown When |
|---|---|
| `UmerNft__MaxLimitReached` | `mintNft()` is called after `MAX_SUPPLY` has been reached |
| `UmerNft__NotEnoughUris` | Constructor is given fewer URIs than `MAX_SUPPLY` |

---

## 🔗 Metadata & Pinata Integration

NFT metadata (JSON files describing name, image, attributes, etc.) is **not stored on-chain**. Instead, this project uses a **TypeScript script** (`script/DeployUmerN...`) that:

1. Uploads NFT images/metadata JSON files to IPFS via **Pinata**
2. Collects the resulting IPFS URIs (`ipfs://<CID>`)
3. Writes/outputs them (see `script/TokenUri.json`) so they can be passed into the contract's constructor as the `uris` array at deployment

This keeps the contract lightweight while ensuring metadata remains decentralized and immutable once pinned.

---

## 🗂️ Project Structure

```
script/
├── DeployUmerNft.ts   # TypeScript script for uploading metadata/images to Pinata
└── TokenUri.json      # Generated IPFS token URIs

src/
└── UmerNft.sol         # Main NFT contract

test/
└── TestUmerNft.t.sol   # Foundry test suite
```

---

## 🛠️ Tech Stack

- **Solidity** `^0.8.34`
- **Foundry** — build, test, and deployment framework
- **OpenZeppelin Contracts** — `ERC721`, `Ownable`, `ERC2981`
- **TypeScript** — off-chain scripting for metadata upload
- **Pinata** — IPFS pinning service for NFT metadata/images

---

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Node.js](https://nodejs.org/) (for the TypeScript upload script)
- A [Pinata](https://pinata.cloud/) account and API key

### Install Dependencies

```bash
forge install
npm install
```

### Build

```bash
forge build
```

### Test

```bash
forge test
```

### Deploy

Use the generated URIs from `script/TokenUri.json` as the constructor argument when deploying `UmerNft.sol` with Foundry.

---

## 📜 License

This project is licensed under the **MIT License**.