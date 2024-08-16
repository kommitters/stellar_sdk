# Changelog

## 0.22.0 (16.08.2024)

- Add hash to handle transaction timeout response. See [PR #374](https://github.com/kommitters/stellar_sdk/pull/374)
- Add new async transaction submission endpoint. See [PR #373](https://github.com/kommitters/stellar_sdk/pull/373)

## 0.21.2 (23.07.2024)

- Update stellar base dependency.

## 0.21.1 (25.04.2024)

* Add stale issues policy. See [PR #363](https://github.com/kommitters/stellar_sdk/pull/363)

## 0.21.0 (04.03.2024)

* Add Dynamic network configuration: Now you should provide Horizon URL and Network Passphrase. See [Issue #352](https://github.com/kommitters/stellar_sdk/issues/352).
* Update all dependencies. See [PR #332](https://github.com/kommitters/stellar_sdk/pull/332).
* Update scorecards allowed endpoints and Security Policy. See [PR #355](https://github.com/kommitters/stellar_sdk/pull/355).
* Delete `config` from `mix.exs` file. See [PR #358](https://github.com/kommitters/stellar_sdk/pull/358).
* Bump Elixir version to 1.12. See [PR #360](https://github.com/kommitters/stellar_sdk/pull/360).

## 0.20.0 (20.12.2023)

* Add Soroban stable Protocol 20 Support.
* Add allowed endpoints for CI, CD, and Scorecards workflows.

## 0.19.0 (27.10.2023)

* Add support for `SCAddress` type in the `SCVal` to obtain the Elixir native value.

## 0.18.1 (11.10.2023)

* Add remaining changes for Protocol 20: Soroban.
  - Add function to be able to obtain native value from a `SCVal`.
  - Fix Horizon API responses related to Effects, Assets, and Soroban Operations.

## 0.18.0 (20.09.2023)

* Add Soroban Preview 11 support.

## 0.17.1 (08.08.2023)

* Allow contract_data key to be any type of `SCVal`

## 0.17.0 (04.08.2023)

* Finish Soroban Preview 10 Support:
  * Support authorized invocation with different accounts.
  * Support Upload Contract WASM.
  * Support Create Contract.
  * Support RestoreFootprint operation.
  * Support BumpFootprintExpiration operation.

## 0.16.1 (27.07.2023)

* Update stellar base dependency.

## 0.16.0 (25.07.2023)

* Add support for contract function invocation with Soroban Preview 10.
* Update all dependencies.

## 0.15.1 (13.06.2023)

* Fix `SCAddress` contract type.

## 0.15.0 (05.06.2023)
* Add Soroban Preview 9 support.
* Add Soroban examples.

## 0.14.0 (08.05.2023)

* Add `sign_xdr` function to `ContractAuth` module to allow signing base 64 contract auth structures.
* Update `InvokeHostFunction` module to allow adding base 64 authorizations.

## 0.13.1 (02.05.2023)
* Update `SCAddress` module to infer address types: account or contract.
* Update all dependencies

## 0.13.0 (26.04.2023)
* Add Soroban Preview 8 support.

## 0.12.0 (19.04.2023)
* CAP-0046 Add support for smart contracts (Soroban preview 7).

## 0.11.8 (16.01.2023)
* Update all dependencies.
* Block egress traffic in GitHub Actions.
* Add stability badge in README.

## 0.11.7 (27.12.2022)
* Add Renovate as dependency update tool.
* Add default permissions as read-only in the CI workflow.

## 0.11.6 (22.12.2022)
* Harden GitHub Actions.

## 0.11.5 (20.12.2022)
* Update build badge and lock to ubuntu-20.04.

## 0.11.4 (31.10.2022)
* Add missing tests in `Signature` module.
* Upgrade `stellar_base` to `v0.8.7` and `ossf/scorecard-action` to `v2.0.6`.

## 0.11.3 (25.10.2022)
* Enable ExCoveralls with parallel builds.

## 0.11.2 (18.10.2022)
* Include OpenSSF BestPractices & Scorecard badges in README.

## 0.11.1 (13.10.2022)
* Fix documentation paths.

## 0.11.0 (13.10.2022)
* Support Signature for the missing signer types: **Hash(x)**, **Ed25519 Signed Payload**.
* Make `SetOptions` operation more user-friendly and descriptive by changing the initialization entries.
* Add `TxBuild.hash/1` function to get the hash of a transaction.
* Expose `TransactionSignature.base_signature/1` function.
* Add example guides for the signature types: **Hash(x)**, **Pre-authorized transaction**, and **Ed25519 Signed Payload**.

## 0.10.2 (21.09.2022)
* Update assets parameters for Offers and Trades.

## 0.10.1 (21.09.2022)
* Fix bug by adding `CreateClaimableBalance` within allowed operations.

## 0.10.0 (15.09.2022)
* Avoid parsing string amount fields to float in Horizon API responses.

## 0.9.3 (05.09.2022)
* Fix bug in `SetOptions` when setting a signer.
* Fix bug in `TimeBounds` to allow backward compatibility (merged with preconditions).

## 0.9.2 (09.08.2022)
* Fix preconditions to allow minimum sequence number field to be optional.
* Add stellar protocol 19 documentation.

## 0.9.1 (08.08.2022)
* Add scorecards actions

## 0.9.0 (05.08.2022)
* Stellar protocol-19 support implementation.
* Add optional fields for account records.
* Add CAP-21 preconditions for transaction attributes.
* Add CAP-40 decorate signature hint and support for signed payload signature.
* Refactor signer key signatures implementation.
* Remove unused alias in tests and fix documentation examples.
* Add Trade Agreggations endpoint.

## 0.8.1 (28.07.2022)
* Refactor Paths endpoint to improve UX.

## 0.8.0 (27.07.2022)
* Add Fee Stats, Paths, and Order Books endpoints.
* Add `Keypair.valid_signature?/3` function.
* Fix documentation examples to create accounts and payments.
* Automate publishing of new releases to Hex.pm using CD.

## 0.7.1 (25.07.2022)
* Add security policy to the repository

## 0.7.0 (27.05.2022)
* Add CreateClaimableBalance, ClaimClaimableBalance, RevokeSponsorship operations.
* Fix PoolID hashing bug.
* Fix base_fee calculation bug.
* Code abstractions for Signer and SignerKey.

## 0.6.0 (18.04.2022)
* Add SetTrustLineFlags operation.
* Add LiquidityPoolWithdraw and LiquidityPoolDeposit operations.
* Functional Horizon pagination feature.
* Better error handling for the TxBuild module.
* Ensure library dependencies are properly loaded on start.

## 0.5.0 (21.03.2022)
* Enable signatures for base64-encoded transaction envelopes.
* Improve library docs.

## 0.4.0 (11.03.2022)
* Compose functional Horizon requests.
* Build structures for Horizon resources.
* Build structures for all the operation types.
* Implement functions to consume Horizon endpoints.
* Querying Horizon docs.

## 0.3.0 (11.02.2022)
* CAP-0027 Add suport for multiplexed accounts.

## 0.2.0 (07.02.2022)
* Add base documentation and initial examples.
* Dynamically update the transaction's BaseFee.
* Submit transactions to Horizon.
* Fetch next account's sequence number from Horizon.
* Retrieve account data from Horizon.
* Implement transaction signatures.
* Add TxBuild validations.
* TxBuild constructions for operations.
* Define a Horizon abstraction. Add a default implementation.
* Define a TxBuild abstraction. Add a default implementation.

## 0.1.1 (05.11.2021)
* Update library namespace from StellarSDK to Stellar.
* Upgrade stellar_base dependency.
* Improve the Horizon layer and the HTTP client implementation.

## 0.1.0 (18.08.2021)
* Horizon HTTP client
