# Upload Contract Code (WASM)
> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to archive the contract upload.

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
alias Stellar.KeyPair

# read file
{:ok, code} = File.read("file_path/file.wasm")

function_args =
  HostFunctionArgs.new(
    type: :upload,
    code: code
  )

function = HostFunction.new(args: function_args)

invoke_host_function_op = InvokeHostFunction.new(functions: [function])

keypair =
  {public_key, _secret} =
  Stellar.KeyPair.from_secret_seed("SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24")

source_account = Account.new(public_key)

{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)

signature = Signature.new(keypair)

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()
|> IO.inspect()

# Simulate Transaction
soroban_data =
  "AAAAAQAAAAe7u0W71jGn1HRVU31RHkxALif4ynfRG6iiRh4VcL5wGgAAAAAAAUBLAAACSAAAAAAAAAAAAAAAAAAAAAAAAAAA"

min_resource_fee = 8552
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