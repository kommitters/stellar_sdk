# Changelog

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
