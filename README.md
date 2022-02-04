# Elixir Stellar SDK
![Build Badge](https://img.shields.io/github/workflow/status/kommitters/stellar_sdk/StellarSDK%20CI/main?style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/stellar_sdk?style=for-the-badge)](https://coveralls.io/github/kommitters/stellar_sdk)
[![Version Badge](https://img.shields.io/hexpm/v/stellar_sdk?style=for-the-badge)](https://hexdocs.pm/stellar_sdk)
![Downloads Badge](https://img.shields.io/hexpm/dt/stellar_sdk?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/stellar_sdk.svg?style=for-the-badge)](https://github.com/kommitters/stellar_sdk/blob/main/LICENSE.md)

**`stellar_sdk`** is an **Elixir library** that provides a client for interfacing with **Horizon** endpoints to retrieve ledger information, and to submit transactions. **`stelar_sdk`** uses the [**`stellar_base`**][base] library to enable the construction, signing and encoding of Stellar primitive XDR constructs.

This library is aimed at developers building Elixir applications that interact with the [**Stellar network**][stellar].

## Documentation
* [**API Reference**][api-reference]
* [**Examples**](/docs/examples.md)

## Installation
[**Available in Hex**][hex], add `stellar_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stellar_sdk, "~> 0.2.0"}
  ]
end
```

## Configuration
```elixir
config :stellar_sdk, network: :test # Default is `:test`. To use the public network, set it to `:public`

```

The default HTTP Client is `:hackney`. Options to `:hackney` can be passed through configuration params.
```elixir
config :stellar_sdk, hackney_opts: [{:connect_timeout, 1000}, {:recv_timeout, 5000}]
```

### Custom HTTP Client
Stellar allows you to use your HTTP client of choice. Specification in [**Stellar.Horizon.Client.Spec**][http_client_spec]

```elixir
config :stellar_sdk, :http_client_impl, YourApp.CustomClientImpl
```

## Usage

### KeyPairs
Stellar relies on public key cryptography to ensure that transactions are secure: every account requires a valid keypair consisting of a public key and a private key.

```elixir
# generate a random key pair
{public_key, secret_seed} = Stellar.KeyPair.random()

# derive a key pair from a secret seed
{public_key, secret_seed} = Stellar.KeyPair.from_secret_seed("SA33J3ACZZCV35FNSS655WXLIPTQOJS6WPQCKKYJSREDQY7KRLECEZSZ")
```

### Building transactions
[Transactions][stellar-docs-tx] are commands that modify the ledger state. They consist of a list of operations (up to 100) used to send payments, enter orders into the decentralized exchange, change settings on accounts, and authorize accounts to hold assets.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# initialize a transaction
Stellar.TxBuild.new(source_account)

# initialize a transaction with options
# allowed options: memo, sequence_number, base_fee, time_bounds
Stellar.TxBuild.new(source_account, memo: memo, sequence_number: sequence_number)
```

#### Memos
A [memo][stellar-docs-memo] contains optional extra information for the transaction. Memos can be one of the following types:

* **`MEMO_TEXT`** : A string encoded using either ASCII or UTF-8, up to 28-bytes long.
* **`MEMO_ID`** A 64 bit unsigned integer.
* **`MEMO_HASH`** : A 32 byte hash.
* **`MEMO_RETURN`** : A 32 byte hash intended to be interpreted as the hash of the transaction the sender is refunding.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# build a memo
memo = Stellar.TxBuild.Memo.new(:none)
memo = Stellar.TxBuild.Memo.new(text: "MEMO")
memo = Stellar.TxBuild.Memo.new(id: 123_4565)
memo = Stellar.TxBuild.Memo.new(hash: "0859239b58d3f32972fc9124559cea7251225f2dbc6f0d83f67dc041e6608510")
memo = Stellar.TxBuild.Memo.new(return: "d83f67dc041e66085100859239b58d3f32924559cea72512272fc915f2dbc6f0")

# add a memo for the transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_memo(memo)
```

#### Sequence number
Each transaction has a [sequence number][stellar-docs-sequence-number] associated with the source account. Transactions follow a strict ordering rule when it comes to processing transactions per account in order to prevent double-spending.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# fetch next account's sequence number from Horizon
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# build a sequence number
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# set the sequence number for the transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.set_sequence_number(sequence_number)
```

#### Base fee
Each transaction incurs a [fee][stellar-docs-fee], which is paid by the source account. When you submit a transaction, you set the maximum that you are willing to pay per operation, but you’re charged the minimum fee possible based on network activity.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# build a fee
base_fee = Stellar.TxBuild.BaseFee.new(1_000)

# set a fee for the transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.set_base_fee(base_fee)
```

#### Time bounds
[TimeBounds][stellar-docs-time-bounds] are optional UNIX timestamps (in seconds), determined by ledger time. A lower and upper bound of when this transaction will be valid.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# no time bounds for a transaction
time_bounds = Stellar.TxBuild.TimeBounds.new(:none)

# time bounds using UNIX timestamps
time_bounds = Stellar.TxBuild.TimeBounds.new(
    min_time: 1_643_558_792,
    max_time: 1_643_990_815
  )

# time bounds using DateTime
time_bounds = Stellar.TxBuild.TimeBounds.new(
    min_time: ~U[2022-01-30 16:06:32.963238Z],
    max_time: ~U[2022-02-04 16:06:55.734317Z]
  )

# timeout
time_bounds = Stellar.TxBuild.TimeBounds.set_timeout(1_643_990_815)

# set the time bounds for the transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.set_time_bounds(time_bounds)
```

#### Operations
[Operations][stellar-docs-list-operations] represent a desired change to the ledger: payments, offers to exchange currency, changes made to account options, etc. Operations are submitted to the Stellar network grouped in a Transaction. Single transactions may have up to 100 operations.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# build a create_account operation
# the destination account does not exist in the ledger
create_account_op = Stellar.TxBuild.CreateAccount.new(
    destination: "GDWD36NCYNN4UFX63F2235QGA2XVGTXG7NQW6MN754SHTQM4XSLTXLYK",
    starting_balance: 2
  )

# build a payment operation
# the destination account should exist in the ledger
payment_op = Stellar.TxBuild.Payment.new(
    destination: "GDWD36NCYNN4UFX63F2235QGA2XVGTXG7NQW6MN754SHTQM4XSLTXLYK",
    asset: :native,
    amount: 5
  )

# add a single operation to a transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operation(create_account_op)


# add multiple operations to a transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operations([create_account_op, payment_op])
```

#### Signing and multi-sig
Stellar uses [signatures][stellar-docs-tx-signatures] as authorization. Transactions always need authorization from at least one public key in order to be considered valid.

In two cases, a transaction may need more than one signature. If the transaction has operations that affect more than one account, it will need authorization from every account in question. A transaction will also need additional signatures if the account associated with the transaction has multiple public keys.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# build an operation
# the destination account should exist in the ledger
operation = Stellar.TxBuild.Payment.new(
    destination: "GDWD36NCYNN4UFX63F2235QGA2XVGTXG7NQW6MN754SHTQM4XSLTXLYK",
    asset: :native,
    amount: 5
  )

# build transaction signatures
# signer accounts should exist in the ledger
signer_key_pair = Stellar.KeyPair.from_secret_seed("SBJJSBBXGKNXALBZ3F3UTHAPKJSESACSKPLW2ZEMM5E5WPVNNKTW55XN")
signer_key_pair2 = Stellar.KeyPair.from_secret_seed("SA2NWVOPQMQYAU5RATOE7HJLMPLQZRNPGSOQGGEG6P2ZSYTWFORY5AV5")

signature1 = Stellar.TxBuild.Signature.new(signer_key_pair)
signature2 = Stellar.TxBuild.Signature.new(signer_key_pair2)

# add a single signature to a transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operation(operation)
  |> Stellar.TxBuild.sign(signature1)


# add multiple signatures to a transaction
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operation(operation)
  |> Stellar.TxBuild.sign([signature1, signature2])
```

#### Transaction envelope
Once a transaction has been filled out, it is wrapped in a [Transaction envelope][stellar-docs-tx-envelope] containing the transaction as well as a set of signatures.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# build an operation
# the destination account should exist in the ledger
operation = Stellar.TxBuild.Payment.new(
    destination: "GDWD36NCYNN4UFX63F2235QGA2XVGTXG7NQW6MN754SHTQM4XSLTXLYK",
    asset: :native,
    amount: 5
  )

# build the transaction signatures
# signer account should exist in the ledger
signer_key_pair = Stellar.KeyPair.from_secret_seed("SBJJSBBXGKNXALBZ3F3UTHAPKJSESACSKPLW2ZEMM5E5WPVNNKTW55XN")
signature = Stellar.TxBuild.Signature.new(signer_key_pair)

# build a base64 transaction envelope
tx =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operation(operation)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

"AAAAAgAAAACuy1AULv6LOdXRYjVYl9u0g62aLg/LPRx+KKAgsCUp2wAAAGQAAA+pAAAAFAAAAAAAAAAAAAAAAQAAAAAAAAABAAAAAL5xix0HYeCnnvADhMs2eqCLBfE+WT3Kh7axgdzPzWX0AAAAAAAAAAAC+vCAAAAAAAAAAAKwJSnbAAAAQMhnGfygZvau5bXFHnJ1rCLIiqiZiI+C4Xf4bWCrxTERPOM/nJKuDottj48bep8NlI42WIUgqZVeQAKykWE74AXPzWX0AAAAQHp0wWKyv80frbOkX3QgOFtflxExX9H46b8ws8fMznSt6/9Le567cqoPxLb/SYvw3Wh6j3B5Vl04CBWyKnLYUwg="
```

#### Submitting a transaction
The transaction can now be submitted to the Stellar network.

```elixir
# set the source account (this accound should exist in the ledger)
source_account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# fetch next account's sequence number from Horizon
{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

# set the sequence number
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# set a memo
memo = Stellar.TxBuild.Memo.new(text: "MEMO")

# build an operation
# the destination account should exist in the ledger
operation = Stellar.TxBuild.Payment.new(
    destination: "GDWD36NCYNN4UFX63F2235QGA2XVGTXG7NQW6MN754SHTQM4XSLTXLYK",
    asset: :native,
    amount: 5
  )

# build the transaction signatures
# signer account should exist in the ledger
signer_key_pair = Stellar.KeyPair.from_secret_seed("SBJJSBBXGKNXALBZ3F3UTHAPKJSESACSKPLW2ZEMM5E5WPVNNKTW55XN")
signature = Stellar.TxBuild.Signature.new(signer_key_pair)

# build a base64 transaction envelope
base64_envelope =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_memo(memo)
  |> Stellar.TxBuild.add_operation(operation)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()

# submit transaction to Horizon
{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(base64_envelope)
```

More examples can be found in the [**tests**][sdk-tests].

---

## Development
* Install any Elixir version above 1.10.
* Compile dependencies: `mix deps.get`.
* Run tests: `mix test`.

## Code of conduct
We welcome everyone to contribute. Make sure you have read the [CODE_OF_CONDUCT][coc] before.

## Contributing
For information on how to contribute, please refer to our [CONTRIBUTING][contributing] guide.

## Changelog
Features and bug fixes are listed in the [CHANGELOG][changelog] file.

## License
This library is licensed under an MIT license. See [LICENSE][license] for details.

## Acknowledgements
Made with 💙 by [kommitters Open Source](https://kommit.co)

[license]: https://github.com/kommitters/stellar_sdk/blob/main/LICENSE.md
[coc]: https://github.com/kommitters/stellar_sdk/blob/main/CODE_OF_CONDUCT.md
[changelog]: https://github.com/kommitters/stellar_sdk/blob/main/CHANGELOG.md
[contributing]: https://github.com/kommitters/stellar_sdk/blob/main/CONTRIBUTING.md
[base]: https://github.com/kommitters/stellar_base
[sdk]: https://github.com/kommitters/stellar_sdk
[sdk-tests]: https://github.com/kommitters/stellar_sdk/blob/main/test/tx_build
[hex]: https://hex.pm/packages/stellar_sdk
[stellar]: https://www.stellar.org/
[http_client_spec]: https://github.com/kommitters/stellar_sdk/blob/main/lib/horizon/client/spec.ex
[api-reference]: https://hexdocs.pm/stellar_sdk/api-reference.html#content
[stellar-docs-tx]: https://developers.stellar.org/docs/glossary/transactions
[stellar-docs-sequence-number]: https://developers.stellar.org/docs/glossary/transactions/#sequence-number
[stellar-docs-fee]: https://developers.stellar.org/docs/glossary/transactions/#fee
[stellar-docs-memo]: https://developers.stellar.org/docs/glossary/transactions/#memo
[stellar-docs-time-bounds]: https://developers.stellar.org/docs/glossary/transactions/#time-bounds
[stellar-docs-tx-envelope]: https://developers.stellar.org/docs/glossary/transactions/#transaction-envelopes
[stellar-docs-list-operations]: https://developers.stellar.org/docs/start/list-of-operations
[stellar-docs-tx-signatures]: https://developers.stellar.org/docs/glossary/multisig/#transaction-signatures
