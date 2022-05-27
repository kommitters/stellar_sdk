# Elixir Stellar SDK
![Build Badge](https://img.shields.io/github/workflow/status/kommitters/stellar_sdk/StellarSDK%20CI/main?style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/stellar_sdk?style=for-the-badge)](https://coveralls.io/github/kommitters/stellar_sdk)
[![Version Badge](https://img.shields.io/hexpm/v/stellar_sdk?style=for-the-badge)](https://hexdocs.pm/stellar_sdk)
![Downloads Badge](https://img.shields.io/hexpm/dt/stellar_sdk?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/stellar_sdk.svg?style=for-the-badge)](https://github.com/kommitters/stellar_sdk/blob/main/LICENSE.md)

The **Stellar SDK** enables the construction, signing and encoding of Stellar [transactions][stellar-docs-tx] and [operations][stellar-docs-list-operations] in **Elixir**, as well as provides a client for interfacing with [Horizon][horizon-api] server REST endpoints to retrieve ledger information, and to submit transactions.

This library is aimed at developers building Elixir applications that interact with the [**Stellar network**][stellar].

## Documentation
The **Stellar SDK** is composed of two complementary components: **`TxBuild`** + **`Horizon`**.
* **`TxBuild`** - used for [**building transactions.**](#building-transactions)
* **`Horizon`** - used for [**querying Horizon.**](#querying-horizon)
* [**Examples.**](/docs/examples.md)

## Installation
[**Available in Hex**][hex], add `stellar_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stellar_sdk, "~> 0.7.0"}
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

## Building transactions

### Accounts
Accounts are the central data structure in Stellar. They hold balances, sign transactions, and issue assets. All entries that persist on the ledger are owned by a particular account.

```elixir
# initialize an account
account = Stellar.TxBuild.Account.new("GDC3W2X5KUTZRTQIKXM5D2I5WG5JYSEJQWEELVPQ5YMWZR6CA2JJ35RW")

```

### Muxed accounts
A **muxed** (or **multiplexed**) account is an account that exists “virtually” under a traditional Stellar account address. It combines the familiar `GABC...` address with a `64-bit` integer `ID` and can be used to distinguish multiple “virtual” accounts that share an underlying “real” account. More details in [**CAP-27**][stellar-cap-27].

```elixir
# initialize an account with a muxed address
account = Stellar.TxBuild.Account.new("MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPQ")

account.account_id
# GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH

account.muxed_id
# 4

```
#### Create a muxed account

```elixir
# create a muxed account
account = Stellar.TxBuild.Account.create_muxed("GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH", 4)

account.address
# MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPQ

```

### KeyPairs
Stellar relies on public key cryptography to ensure that transactions are secure: every account requires a valid keypair consisting of a public key and a private key.

```elixir
# generate a random key pair
{public_key, secret_seed} = Stellar.KeyPair.random()

# derive a key pair from a secret seed
{public_key, secret_seed} = Stellar.KeyPair.from_secret_seed("SA33J3ACZZCV35FNSS655WXLIPTQOJS6WPQCKKYJSREDQY7KRLECEZSZ")
```

### Transactions
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
{:ok, tx_build} =
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

# set the sequence number
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

# set the sequence number for the transaction
{:ok, tx_build} =
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
{:ok, tx_build} =
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
{:ok, tx_build} =
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
{:ok, tx_build} =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operation(create_account_op)


# add multiple operations to a transaction
{:ok, tx_build} =
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
{:ok, tx_build} =
  source_account
  |> Stellar.TxBuild.new()
  |> Stellar.TxBuild.add_operation(operation)
  |> Stellar.TxBuild.sign(signature1)


# add multiple signatures to a transaction
{:ok, tx_build} =
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
source_account
|> Stellar.TxBuild.new()
|> Stellar.TxBuild.add_operation(operation)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

{:ok, "AAAAAgAAAACuy1AULv6LOdXRYjVYl9u0g62aLg/LPRx+KKAgsCUp2wAAAGQAAA+pAAAAFAAAAAAAAAAAAAAAAQAAAAAAAAABAAAAAL5xix0HYeCnnvADhMs2eqCLBfE+WT3Kh7axgdzPzWX0AAAAAAAAAAAC+vCAAAAAAAAAAAKwJSnbAAAAQMhnGfygZvau5bXFHnJ1rCLIiqiZiI+C4Xf4bWCrxTERPOM/nJKuDottj48bep8NlI42WIUgqZVeQAKykWE74AXPzWX0AAAAQHp0wWKyv80frbOkX3QgOFtflxExX9H46b8ws8fMznSt6/9Le567cqoPxLb/SYvw3Wh6j3B5Vl04CBWyKnLYUwg="}
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
{:ok, base64_envelope} =
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

## Querying Horizon
Horizon is an API for interacting with the Stellar network.

To make it possible to explore the millions of records for resources like transactions and operations, this library paginates the data it returns for collection-based resources. Each individual transaction, operation, ledger, etc. is returned as a record.

```elixir
{:ok,
 %Ledger{
   base_fee_in_stroops: 100,
   closed_at: ~U[2015-09-30 17:16:29Z],
   failed_transaction_count: 0,
   fee_pool: 3.0e-5,
   ...
 }} = Ledgers.retrieve(1234)
```

A group of records is called a **collection**, records are returned as a list in the [**Stellar.Horizon.Collection**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Collection.html#content) structure. To move between pages of a collection of records, use the `next` and `prev` attributes.


```elixir
{:ok,
 %Stellar.Horizon.Collection{
   next: #Function<1.1390483/0 in Stellar.Horizon.Collection.paginate/1>,
   prev: #Function<1.1390483/0 in Stellar.Horizon.Collection.paginate/1>,
   records: [
     %Stellar.Horizon.Ledger{...},
     %Stellar.Horizon.Ledger{...},
     %Stellar.Horizon.Ledger{...}
   ]
 }} = Stellar.Horizon.Ledgers.all()
```

### Pagination
The [HAL format links](https://developers.stellar.org/api/introduction/response-format/) returned with the Horizon response are converted into functions you can call on the returned structure. This allows you to simply use `next.()` and `prev.()` to page through results.

```elixir
{:ok,
 %Stellar.Horizon.Collection{
   next: paginate_next_fn,
   prev: paginate_prev_fn,
   records: [...]
 }} = Stellar.Horizon.Transactions.all()

# next page records for the collection
paginate_next_fn.()

{:ok,
 %Stellar.Horizon.Collection{
   next: paginate_next_fn,
   prev: paginate_prev_fn,
   records: [...]
 }}

# prev page records for the collection
paginate_prev_fn.()

{:ok,
 %Stellar.Horizon.Collection{
   next: paginate_next_fn,
   prev: paginate_prev_fn,
   records: []
 }}
```

### Accounts
```elixir
# retrieve an account
Stellar.Horizon.Accounts.retrieve("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")

# fetch the ledger's sequence number for the account
Stellar.Horizon.Accounts.fetch_next_sequence_number("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")

# list accounts
Stellar.Horizon.Accounts.all(limit: 10, order: :asc)

# list accounts by sponsor
Stellar.Horizon.Accounts.all(sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")

# list accounts by signer
Stellar.Horizon.Accounts.all(signer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)

# list accounts by canonical asset address
Stellar.Horizon.Accounts.all(asset: "TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)

# list account's transactions
Stellar.Horizon.Accounts.list_transactions("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)

# list account's payments
Stellar.Horizon.Accounts.list_payments("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
```

See [**Stellar.Horizon.Accounts**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Accounts.html#content) for more details.

### Transactions
```elixir
# submit a transaction
Stellar.Horizon.Transactions.create(base64_tx_envelope)

# retrieve a transaction
Stellar.Horizon.Transactions.retrieve("5ebd5c0af4385500b53dd63b0ef5f6e8feef1a7e1c86989be3cdcce825f3c0cc")

# list transactions
Stellar.Horizon.Transactions.all(limit: 10, order: :asc)

# include failed transactions
Stellar.Horizon.Transactions.all(limit: 10, include_failed: true)

# list transaction's effects
Stellar.Horizon.Transactions.list_effects("6b983a4e0dc3c04f4bd6b9037c55f70a09c434dfd01492be1077cf7ea68c2e4a", limit: 20)

# list transaction's operations
Stellar.Horizon.Transactions.list_operations("6b983a4e0dc3c04f4bd6b9037c55f70a09c434dfd01492be1077cf7ea68c2e4a", limit: 20)

# join transactions in the operations response
Stellar.Horizon.Transactions.list_operations("6b983a4e0dc3c04f4bd6b9037c55f70a09c434dfd01492be1077cf7ea68c2e4a", join: "transactions")
```

See [**Stellar.Horizon.Transactions**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Transactions.html#content) for more details.


### Operations
```elixir
# retrieve an operation
Stellar.Horizon.Operations.retrieve(121693057904021505)

# list operations
Stellar.Horizon.Operations.all(limit: 10, order: :asc)

# include failed operations
Stellar.Horizon.Operations.all(limit: 10, include_failed: true)

# include operation's transactions
Stellar.Horizon.Operations.all(limit: 10, join: "transactions")

# list operation's payments
Stellar.Horizon.Operations.list_payments(limit: 20)

# list operation's effects
Stellar.Horizon.Operations.list_effects(121693057904021505, limit: 20)
```

See [**Stellar.Horizon.Operations**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Operations.html#content) for more details.


### Assets
```elixir
# list ledger's assets
Stellar.Horizon.Assets.all(limit: 20, order: :desc)

# list assets by asset issuer
Stellar.Horizon.Assets.all(asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")

# list assets by asset code
Stellar.Horizon.Assets.list_by_asset_code("TEST")
Stellar.Horizon.Assets.all(asset_code: "TEST")

# list assets by asset issuer
Stellar.Horizon.Assets.all(asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
Stellar.Horizon.Assets.list_by_asset_issuer("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
```

See [**Stellar.Horizon.Assets**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Assets.html#content) for more details.


### Ledgers
```elixir
# retrieve a ledger
Stellar.Horizon.Ledgers.retrieve(27147222)

# list ledgers
Stellar.Horizon.Ledgers.all(limit: 10, order: :asc)

# list ledger's transactions
Stellar.Horizon.Ledgers.list_transactions(27147222, limit: 20)

# list ledger's operations
Stellar.Horizon.Ledgers.list_operations(27147222, join: "transactions")

# list ledger's payments including failed transactions
Stellar.Horizon.Ledgers.list_payments(27147222, include_failed: true)

# list ledger's effects
Stellar.Horizon.Ledgers.list_effects(27147222, limit: 20)
```

See [**Stellar.Horizon.Ledgers**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Ledgers.html#content) for more details.


### Offers
```elixir
# list offers
Stellar.Horizon.Offers.all(limit: 20, order: :asc)

# list offers by sponsor
Stellar.Horizon.Offers.all(sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")

# list offers by seller
Stellar.Horizon.Offers.all(seller: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)

# list offers by selling_asset_issuer
Stellar.Horizon.Offers.all(selling_asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)

# list offers by buying_asset_type and buying_asset_code
Stellar.Horizon.Offers.all(buying_asset_type: "credit_alphanum4", buying_asset_code: "TEST")

# list offer's trades
Stellar.Horizon.Offers.list_trades(165563085, limit: 20)
```

See [**Stellar.Horizon.Offers**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Offers.html#content) for more details.


### Trades
```elixir
# list tardes
Stellar.Horizon.Trades.all(limit: 20, order: :asc)

# list trades by offer_id
Stellar.Horizon.Trades.all(offer_id: 165563085)

# list trades by base_asset_type and base_asset_code
Stellar.Horizon.Trades.all(base_asset_type: "credit_alphanum4", base_asset_code: "TEST")

# list trades by counter_asset_issuer
Stellar.Horizon.Trades.all(counter_asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)

# list trades by trade_type
Stellar.Horizon.Trades.all(trade_type: "liquidity_pools", limit: 20)
```

See [**Stellar.Horizon.Trades**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Trades.html#content) for more details.


### ClaimableBalances
```elixir
# retrieve a claimable balance
Stellar.Horizon.ClaimableBalances.retrieve("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695")

# list claimable balances
Stellar.Horizon.ClaimableBalances.all(limit: 2, order: :asc)

# list claimable balances by sponsor
Stellar.Horizon.ClaimableBalances.list_by_sponsor("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
Stellar.Horizon.ClaimableBalances.all(sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")

# list claimable balances by claimant
Stellar.Horizon.ClaimableBalances.list_by_claimant("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
Stellar.Horizon.ClaimableBalances.all(claimant: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)

# list claimable balances by canonical asset address
Stellar.Horizon.ClaimableBalances.list_by_asset("TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
Stellar.Horizon.ClaimableBalances.all(asset: "TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)

# list claimable balance's transactions
Stellar.Horizon.ClaimableBalances.list_transactions("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695", limit: 20)

# list claimable balance's operations
Stellar.Horizon.ClaimableBalances.list_operations("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695", limit: 20)

# join transactions in the operations response
Stellar.Horizon.ClaimableBalances.list_operations("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695", join: "transactions")
```

See [**Stellar.Horizon.Balances**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.ClaimableBalances.html#content) for more details.


### LiquidityPools
```elixir
# retrieve a liquidity pool
Stellar.Horizon.LiquidityPools.retrieve("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc")

# list liquidity pools
Stellar.Horizon.LiquidityPools.all(limit: 2, order: :asc)

# list liquidity pools by reserves
Stellar.Horizon.LiquidityPools.all(reserves: "TEST:GCXMW..., TEST2:GCXMW...")

# list liquidity pools by account
Stellar.Horizon.LiquidityPools.all(account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)

# list liquidity pool's effects
Stellar.Horizon.LiquidityPools.list_effects("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)

# list liquidity pool's trades
Stellar.Horizon.LiquidityPools.list_trades("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)

# list liquidity pool's transactions
Stellar.Horizon.LiquidityPools.list_transactions("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)

# list liquidity pool's operations
Stellar.Horizon.LiquidityPools.list_operations("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)
```

See [**Stellar.Horizon.Pools**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.LiquidityPools.html#content) for more details.


### Effects
```elixir
# list effects
Stellar.Horizon.Effects.all(limit: 10, order: :asc)
```

See [**Stellar.Horizon.Effects**](https://hexdocs.pm/stellar_sdk/Stellar.Horizon.Effects.html#content) for more details.

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
[horizon-api]: https://developers.stellar.org/api/introduction
[http_client_spec]: https://github.com/kommitters/stellar_sdk/blob/main/lib/horizon/client/spec.ex
[stellar-docs-tx]: https://developers.stellar.org/docs/glossary/transactions
[stellar-docs-sequence-number]: https://developers.stellar.org/docs/glossary/transactions/#sequence-number
[stellar-docs-fee]: https://developers.stellar.org/docs/glossary/transactions/#fee
[stellar-docs-memo]: https://developers.stellar.org/docs/glossary/transactions/#memo
[stellar-docs-time-bounds]: https://developers.stellar.org/docs/glossary/transactions/#time-bounds
[stellar-docs-tx-envelope]: https://developers.stellar.org/docs/glossary/transactions/#transaction-envelopes
[stellar-docs-list-operations]: https://developers.stellar.org/docs/start/list-of-operations
[stellar-docs-tx-signatures]: https://developers.stellar.org/docs/glossary/multisig/#transaction-signatures
[stellar-cap-27]: https://stellar.org/protocol/cap-27
