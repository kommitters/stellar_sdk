# Bump Footprint Expiration

> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to achieve the contract upload.

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  BumpFootprintExpiration,
  LedgerKey,
  SCAddress
  SCVal,
  SequenceNumber,
  Signature,
  SorobanTransactionData
}

alias Stellar.KeyPair

contract_address = "CAMGSYINVVL6WP3Q5WPNL7FS4GZP37TWV7MKIRQF5QMYLK3N2SW4P3RC"
contract_sc_address = SCAddress.new(contract_address)
key = SCVal.new(ledger_key_contract_instance: nil)

keypair =
  {public_key, _secret} =
  Stellar.KeyPair.from_secret_seed("SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK")

contract_data =
  LedgerKey.new(
    {:contract_data,
     [
       contract: contract_sc_address,
       key: key,
       durability: :persistent,
       body_type: :data_entry
     ]}
  )

hash= StellarBase.StrKey.decode!(contract_address, :contract)
contract_code = LedgerKey.new({:contract_code, [hash: hash, body_type: :data_entry]})
footprint = LedgerFootprint.new(read_only: [contract_data, contract_code])

soroban_data =
TxSorobanResources.new(
  footprint: footprint,
  instructions: 0,
  read_bytes: 0,
  write_bytes: 0,
  extended_meta_data_size_bytes: 0
)
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
|> Stellar.TxBuild.envelope()

# Simulate Transaction
soroban_data =
      "AAAAAAAAAAIAAAAGAAAAARhpYQ2tV+s/cO2e1fyy4bL9/nav2KRGBewZhatt1K3HAAAAFAAAAAEAAAAAAAAABxhpYQ2tV+s/cO2e1fyy4bL9/nav2KRGBewZhatt1K3HAAAAAAAAAAAAAAAAAAABLAAAAAAAAAJYAAAAAAAAAHY="

min_resource_fee = 11_516
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
