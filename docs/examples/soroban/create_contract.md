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
  InvokeHostFunction,
  HostFunction,
  HostFunctionArgs,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts

wasm_id = <<some binary here>>

function_args =
  HostFunctionArgs.new(
    type: :create,
    wasm_id: wasm_id
  )

function = HostFunction.new(args: function_args)

invoke_host_function_op = InvokeHostFunction.new(functions: [function])

keypair =
  {public_key, _secret} =
  Stellar.KeyPair.from_secret_seed("SC5J4N7JTTWK6QS34OFEX67PB7X2UDLZMOPX2ORA5KTPQHFCESBKZ46D")

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
  "AAAAAQAAAAdw47HdjY6bhECndnofWxQ6D1mDQaYxvykdKi4f7bz4ygAAAAEAAAAGSCB+H17w48TbOf0PtCgDnGu0zOOzuVjMYSzmMYZOD0kAAAAUAAFCiwAAQ1QAAACAAAAAqAAAAAAAAAAhAAAAAA=="

min_resource_fee = 54439
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
  InvokeHostFunction,
  HostFunction,
  HostFunctionArgs,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts

keypair = {public_key, _secret} = Stellar.KeyPair.from_secret_seed("SCA...3EK")

asset = Asset.new(code: :ABC, issuer: public_key)

function_args =
  HostFunctionArgs.new(
    type: :create,
    asset: asset
  )

function = HostFunction.new(args: function_args)

invoke_host_function_op = InvokeHostFunction.new(functions: [function])

source_account = Account.new(public_key)

{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)

signature = Signature.new(keypair)

# Use this XDR to simulate the transaction and get soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()
|> IO.inspect()

soroban_data =
  "AAAAAAAAAAQAAAAGy7BJuM4i1Q0rEQ2fd0X9qJqvJugM2lEpbY21qRJAzmsAAAAPAAAACE1FVEFEQVRBAAAABsuwSbjOItUNKxENn3dF/aiaryboDNpRKW2NtakSQM5rAAAAEAAAAAEAAAABAAAADwAAAAVBZG1pbgAAAAAAAAbLsEm4ziLVDSsRDZ93Rf2omq8m6AzaUSltjbWpEkDOawAAABAAAAABAAAAAQAAAA8AAAAJQXNzZXRJbmZvAAAAAAAABsuwSbjOItUNKxENn3dF/aiaryboDNpRKW2NtakSQM5rAAAAFAAD2ZUAAADgAAADFAAAA/QAAAAAAAAAxgAAAAA="

min_resource_fee = 12_7568
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