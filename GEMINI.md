# Gemini Code Assistant Context

## Project Overview

This project is the Elixir Stellar SDK, a library for interacting with the Stellar network. It allows developers to build, sign, and encode Stellar transactions and operations, as well as query the Horizon API for ledger information.

The SDK is composed of two main components:

*   **TxBuild**: For constructing Stellar transactions. It provides a comprehensive API to create and customize transactions, including adding operations, memos, preconditions, and signatures.
*   **Horizon**: A client for the Horizon API, which allows developers to query for information about accounts, transactions, operations, ledgers, and more.

The project is built with Elixir and uses `mix` for dependency management and running tasks.

## Building and Running

### Dependencies

Dependencies are managed with `mix` and are listed in the `mix.exs` file. Key dependencies include:

*   `stellar_base`: For Stellar XDR data structures.
*   `ed25519`: For cryptographic signing.
*   `hackney`: As the default HTTP client.
*   `jason`: For JSON parsing.

### Key Commands

*   **Install dependencies:**
    ```bash
    mix deps.get
    ```
*   **Run tests:**
    ```bash
    mix test
    ```
*   **Format code:**
    ```bash
    mix format
    ```

## Development Conventions

*   **Testing**: The project has a comprehensive test suite in the `test` directory. All new contributions should include corresponding tests.
*   **Formatting**: Code should be formatted using `mix format`.
*   **Branching**: Development should be done on topic branches, not directly on the `main` branch.
*   **Commits**: Commit messages should be descriptive and follow the guidelines in the `CONTRIBUTING.md` file.
*   **Pull Requests**: Pull requests should be focused on a single issue and should be rebased against the `main` branch.
