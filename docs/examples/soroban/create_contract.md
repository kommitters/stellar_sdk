# Create Contract

> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to achieve the contract creation, additionally we need the binary id of an already uploaded contract WASM.

There are two types of contract creations:

### From an uploaded contract WASM

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  ContractExecutable,
  ContractIDPreimage,
  ContractIDPreimageFromAddress,
  CreateContractArgs,
  HostFunction,
  InvokeHostFunction,
  SequenceNumber,
  Signature,
  SCAddress
}

alias Stellar.KeyPair
alias Stellar.Horizon.Accounts

wasm_ref = <<some binary here>>
address = SCAddress.new("GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM")
salt = :crypto.strong_rand_bytes(32)

address_preimage = ContractIDPreimageFromAddress.new(address: address, salt: salt)
contract_id_preimage = ContractIDPreimage.new(from_address: address_preimage)
contract_executable = ContractExecutable.new(wasm_ref: wasm_ref)

create_contract_args =
  CreateContractArgs.new(
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable
  )

host_function = HostFunction.new(create_contract: create_contract_args)

invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)

keypair =
  {public_key, _secret} =
  KeyPair.from_secret_seed("SC5J4N7JTTWK6QS34OFEX67PB7X2UDLZMOPX2ORA5KTPQHFCESBKZ46D")

source_account = Account.new(public_key)

{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)

signature =
  Signature.new(keypair)

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
soroban_data =
  "AAAAAAAAAAEAAAAHuoVwkiq7sFT5+6wPecWIC3zW3SXzDactjjMN9VUNzQIAAAAAAAAAAQAAAAYAAAABet+3VCiKSYoZDd/Ce32Dtp9tYwNFc64V/QfdZUJm4boAAAAUAAAAAQAAAAAAAX/UAAACyAAAAKQAAADYAAAAAAAAACs="

auth = [
  "AAAAAAAAAAEAAAAAAAAAAAAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1t3O7skFonbhP9PT+l5IGaavsMV+AyUtQF88+kCpS/YbAAAAAIw32Y19ZRfshxeO+Nw4BNSkE0ZhibcEWId4SVzs0PZPAAAAAA=="
]

invoke_host_function_op = InvokeHostFunction.set_auth(invoke_host_function_op, auth)
min_resource_fee = 38_733
fee = BaseFee.new(min_resource_fee + 100)

# Use the XDR generated here to send it to the futurenet
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.set_base_fee(fee)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

```

### Asset Contract

```elixir

alias Stellar.TxBuild.{
  Account,
  Asset,
  BaseFee,
  CreateContractArgs,
  ContractIDPreimage,
  ContractExecutable,
  HostFunction,
  InvokeHostFunction,
  SequenceNumber,
  Signature
}

alias Stellar.KeyPair
alias Stellar.Horizon.Accounts

keypair = {public_key, _secret} = KeyPair.from_secret_seed("SCA...3EK")

asset = Asset.new(code: :ABC, issuer: public_key)

contract_id_preimage = ContractIDPreimage.new(from_asset: asset)
    contract_executable = ContractExecutable.new(:token)

create_contract_args =
  CreateContractArgs.new(
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable
  )

host_function = HostFunction.new(create_contract: create_contract_args)

invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)

source_account = Account.new(public_key)

{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)

signature = Signature.new(keypair)

# Use this XDR to simulate the transaction and get soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

soroban_data =
  "AAAAAAAAAAAAAAABAAAABgAAAAH3mbzcS3de+8X2xbTs9y5hcKA2c5Nvip1EIroM6x+eqAAAABQAAAABAAAAAAAEIzgAAAA0AAACGAAAA0gAAAAAAAAApQ=="

min_resource_fee = 36_155
fee = BaseFee.new(min_resource_fee + 100)

# Use the XDR generated here to send it to the futurenet
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.set_base_fee(fee)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

```
