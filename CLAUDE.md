# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Core Development Tasks
- **Install dependencies**: `mix deps.get`
- **Run tests**: `mix test`
- **Run single test**: `mix test test/path/to/test_file.exs`
- **Run tests with specific pattern**: `mix test --grep "pattern"`
- **Format code**: `mix format`
- **Lint code**: `mix credo` (with strict mode enabled)
- **Type checking**: `mix dialyzer` (Dialyxir for static analysis)
- **Generate docs**: `mix docs`
- **Check test coverage**: `mix coveralls` or `mix coveralls.html`

### Mix Project Configuration
- Elixir version requirement: `~> 1.12`
- Test coverage tool: ExCoveralls
- Code linting: Credo (strict mode, max function arity of 10)
- Static analysis: Dialyxir
- Documentation: ExDoc

## Code Architecture

### High-Level Structure
This is the **Elixir Stellar SDK**, a comprehensive library for interacting with the Stellar network. The codebase is organized around two main components:

1. **`TxBuild`** (`lib/tx_build/`) - Transaction construction and signing
2. **`Horizon`** (`lib/horizon/`) - HTTP client for Horizon API interactions

### Core Modules

#### Transaction Building (`lib/tx_build/`)
- **`Stellar.TxBuild`** - Main transaction builder API with behavior pattern
- **`Stellar.TxBuild.Default`** - Default implementation of transaction building
- **Operations** - Individual operation types (Payment, CreateAccount, etc.)
- **Components** - Account, Memo, Signature, Preconditions, TimeBounds, etc.
- Uses behavior pattern for pluggable implementations via `:tx_build_impl` config

#### Horizon Client (`lib/horizon/`)
- **Resource modules** - Accounts, Transactions, Operations, Ledgers, etc.
- **Client abstraction** - HTTP client interface with `:http_client_impl` config
- **Server configuration** - Public, testnet, futurenet, and custom endpoints
- **Collection handling** - Pagination support with HAL format links
- **Error handling** - Structured error responses and mapping

#### Utilities
- **`Stellar.KeyPair`** - Key generation and management (Ed25519)
- **`Stellar.Network`** - Network passphrases (testnet, public, etc.)

### Key Design Patterns

#### Behavior Pattern
The codebase uses Elixir behaviors extensively:
- `Stellar.TxBuild.Spec` - Defines transaction building interface
- `Stellar.KeyPair.Spec` - Defines key pair operations interface
- Implementation swappable via application configuration

#### Configuration-Based Implementation Injection
- `:tx_build_impl` - Transaction building implementation (defaults to `Stellar.TxBuild.Default`)
- `:http_client_impl` - HTTP client implementation (defaults to hackney)
- `:hackney_opts` - HTTP client options

#### Resource-Collection Pattern
Horizon resources follow a consistent pattern:
- Individual resource retrieval (e.g., `retrieve/2`)
- Collection listing with filtering (e.g., `all/2`)
- Related resource listing (e.g., `list_transactions/3`)
- Pagination handled via HAL links converted to functions

## Important Development Notes

### Network Configuration
- Default network is **testnet** (`Stellar.Network.testnet_passphrase/0`)
- Production requires explicit **public network** configuration
- Support for futurenet and custom networks

### Protocol Version Support
The SDK supports Stellar Protocol versions 18-21 with specific version requirements:
- Protocol 20: requires SDK v0.20+
- Protocol 21: requires SDK v0.21.2+

### Key Dependencies
- **stellar_base**: Core Stellar primitives (~> 0.16)
- **hackney**: Default HTTP client (~> 1.17)
- **jason**: JSON encoding/decoding (~> 1.0)
- **ed25519**: Cryptographic operations (~> 1.3)

### Testing Structure
- Tests mirror the `lib/` structure exactly
- Heavy use of mocking for HTTP interactions
- Comprehensive coverage of transaction building scenarios
- Integration tests for Horizon client functionality

### Code Quality Standards
- **Credo**: Strict mode enabled, function arity limited to 10
- **Formatter**: Standard Elixir formatting rules
- **Dialyxir**: Static type analysis for better code quality
- **ExCoveralls**: Test coverage reporting and tracking

### Stellar-Specific Concepts
When working with this codebase, understand these Stellar concepts:
- **Muxed accounts**: Virtual accounts under a real account with 64-bit ID
- **Operations**: Atomic units of change (payments, offers, account creation)
- **Preconditions**: Time bounds, ledger bounds, sequence number constraints
- **Signatures**: Ed25519, hash(x), and signed payload signature types
- **Transaction envelopes**: Signed transaction containers for network submission

## Recommended Workflow

1. **Transaction Building**: Start with `Stellar.TxBuild.new/2`, add operations, set sequence numbers, sign, and generate envelope
2. **Horizon Queries**: Use appropriate resource modules (`Accounts`, `Transactions`, etc.) with server configuration
3. **Testing**: Write tests in corresponding test directory structure, mock HTTP calls for Horizon interactions
4. **Documentation**: Follow existing documentation patterns, especially for public APIs

This SDK is production-ready with extensive test coverage and follows Stellar network best practices.