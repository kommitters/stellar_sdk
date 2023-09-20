# Restore Footprint

The `RestoreFootprint` operation is used to restore a contract data entry's. The restored entry will have its expiration ledger bumped to the [minimums](https://github.com/stellar/stellar-core/blob/2109a168a895349f87b502ae3d182380b378fa47/src/ledger/NetworkConfig.h#L77-L78) the network allows for newly created entries, which is 4096 + current ledger for persistent entries.

A contract instance, wasm hash, and data storage entry (persistent/instance) can expire, so in case you need any of these already expired info, you can use this restore for it.
Read more about it:

- https://soroban.stellar.org/docs/fundamentals-and-concepts/state-expiration#restorefootprintop
- https://docs.rs/soroban-sdk/latest/soroban_sdk/storage/struct.Storage.html

In this example, we will restore a contract instance of an already expired contract in the network.

> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to achieve the restore footprint.

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  LedgerFootprint,
  LedgerKey,
  RestoreFootprint,
  SCAddress,
  SCVal,
  SequenceNumber,
  Signature,
  SorobanResources,
  SorobanTransactionData
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

contract_sc_address = SCAddress.new("CAMGSYINVVL6WP3Q5WPNL7FS4GZP37TWV7MKIRQF5QMYLK3N2SW4P3RC")
key = SCVal.new(ledger_key_contract_instance: nil)

keypair = {public_key, _secret} = KeyPair.from_secret_seed("SCA...3EK")

contract_data =
  LedgerKey.new(
    {:contract_data,
     [
       contract: contract_sc_address,
       key: key,
       durability: :persistent
     ]}
  )

footprint = LedgerFootprint.new(read_write: [contract_data])

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
restore_footprint_op = RestoreFootprint.new()

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(bump_footprint_op)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
soroban_data =
      "AAAAAAAAAAAAAAABAAAABgAAAAHO/TJVxUVOMxLMlSFIVfYhn4K3jGxh57QYIImRFZhhywAAABQAAAABAAAAAAAAAAAAAAS0AAAEtAAACWgAAAAAAAAB1w=="

min_resource_fee = 37_351
fee = BaseFee.new(min_resource_fee + 100)

# Use the XDR generated here to send it to the futurenet
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(restore_footprint_op)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.set_base_fee(fee)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

```
