# Changelog

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
