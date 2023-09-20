# Bump Footprint Expiration

The `BumpFootprintExpirationOp` operation is used to extend a contract data entry's lifetime.

A contract instance, wasm hash, and data storage entry (persistent/instance/temporary) can expire, so you can use this bump operation to extend its lifetime.
Read more about it:

- https://soroban.stellar.org/docs/fundamentals-and-concepts/state-expiration#bumpfootprintexpirationop
- https://docs.rs/soroban-sdk/latest/soroban_sdk/storage/struct.Storage.html

In this example, we will bump the contract instance and the wasm of an already deployed contract in the network, adding 1000 ledgers to it.

> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to achieve the bump footprint expiration.

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  BumpFootprintExpiration,
  LedgerFootprint,
  LedgerKey,
  SCAddress,
  SCVal,
  SequenceNumber,
  Signature,
  SorobanResources,
  SorobanTransactionData
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

contract_address = "CCNVHP2UAOJAICTQUDSRVZDCB5OJKGQNOJFPOXINELWQHGX33EG34NV2"
contract_sc_address = SCAddress.new(contract_address)
key = SCVal.new(ledger_key_contract_instance: nil)

keypair =
  {public_key, _secret} = KeyPair.from_secret_seed("SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK")

contract_data =
  LedgerKey.new(
    {:contract_data,
     [
       contract: contract_sc_address,
       key: key,
       durability: :persistent
     ]}
  )

hash = Base.decode16!("d14f427a7d4ad78008e5f18a8d9ed7c9dcc02a868995064b9a88a5a684b86624", case: :lower)
contract_code = LedgerKey.new({:contract_code, [hash: hash]})
footprint = LedgerFootprint.new(read_only: [contract_data, contract_code])

soroban_data =
[
  footprint: footprint,
  instructions: 0,
  read_bytes: 0,
  write_bytes: 0
]
|> SorobanResources.new()
|> (&SorobanTransactionData.new(resources: &1, refundable_fee: 0)).()
|> SorobanTransactionData.to_xdr()

source_account = Account.new(public_key)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)
signature = Signature.new(keypair)
bump_footprint_op = BumpFootprintExpiration.new(ledgers_to_expire: 1000)

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(bump_footprint_op)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
soroban_data =
      "AAAAAAAAAAIAAAAGAAAAAZtTv1QDkgQKcKDlGuRiD1yVGg1ySvddDSLtA5r72Q2+AAAAFAAAAAEAAAAH0U9Cen1K14AI5fGKjZ7XydzAKoaJlQZLmoilpoS4ZiQAAAAAAAAAAAAAAxwAAAAAAAAAAAAAGzI="

min_resource_fee = 13_946
fee = BaseFee.new(min_resource_fee + 100)

# Use the XDR generated here to send it to the futurenet
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(bump_footprint_op)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.set_base_fee(fee)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

```
