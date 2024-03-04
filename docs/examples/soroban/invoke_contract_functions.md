# Invoke Contract Function

> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to achieve the contract function invocation.

There are three ways to perform a contract function invocation:

### Without Contract Authorization

> **Note**
> Used to invoke functions that don't require any authorization.

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  InvokeContractArgs,
  InvokeHostFunction,
  HostFunction,
  SCAddress,
  SCVal,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

server = Stellar.Horizon.Server.new()
contract_address = SCAddress.new("CAMGSYINVVL6WP3Q5WPNL7FS4GZP37TWV7MKIRQF5QMYLK3N2SW4P3RC")

function_name = "hello"
args =
  InvokeContractArgs.new(
    contract_address: contract_address,
    function_name: function_name,
    args: [SCVal.new(string: "dev")]
  )

host_function = HostFunction.new(invoke_contract: args)
invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)
keypair = {public_key, _secret} = KeyPair.from_secret_seed("SDR...Q24")
source_account = Account.new(public_key)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(server, public_key)
sequence_number = SequenceNumber.new(seq_num)

signature = Signature.new(keypair)

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# simulate transaction
soroban_data =
  "AAAAAAAAAAIAAAAGAAAAAQmM+SjuK6EFG2xjRoNDYSKeKWmaP+sPIZ2z+rHmx5I0AAAAFAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAAAAE6LRgAAGDQAAAAAAAAAAAAAAAw="

min_resource_fee = 64_141
fee = BaseFee.new(min_resource_fee)

# Use the XDR generated here to send it to the futurenet
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.set_base_fee(fee)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

```

### With Authorization

> **Note**
> Used when the tx submitter and the invoker are the same.

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  InvokeContractArgs,
  InvokeHostFunction,
  HostFunction,
  SCVal,
  SCAddress,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

server = Stellar.Horizon.Server.new()
contract_address = SCAddress.new("CAMGSYINVVL6WP3Q5WPNL7FS4GZP37TWV7MKIRQF5QMYLK3N2SW4P3RC")

function_name = "inc"
keypair = {public_key, _secret} = KeyPair.from_secret_seed("SDR...Q24")
address_type = SCAddress.new(public_key)
address = SCVal.new(address: address_type)

args =
  InvokeContractArgs.new(
    contract_address: contract_address,
    function_name: function_name,
    args: [address, SCVal.new(u128: %{hi: 0, lo: 2})]
  )

host_function = HostFunction.new(invoke_contract: args)
invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)
source_account = Account.new(public_key)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(server, public_key)
sequence_number = SequenceNumber.new(seq_num)
signature = Signature.new(keypair)

# Use this XDR to simulate the transaction and get the soroban_data, the invoke_host_function auth
# and the min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
soroban_data =
  "AAAAAAAAAAEAAAAHjDfZjX1lF+yHF4743DgE1KQTRmGJtwRYh3hJXOzQ9k8AAAABAAAABgAAAAEJjPko7iuhBRtsY0aDQ2Einilpmj/rDyGds/qx5seSNAAAABQAAAABAE9HyAAAGDQAAADIAAAAAAAAACU="

auth = [
  "AAAAAAAAAAAAAAABCYz5KO4roQUbbGNGg0NhIp4paZo/6w8hnbP6sebHkjQAAAADaW5jAAAAAAIAAAASAAAAAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAAkAAAAAAAAAAAAAAAAAAAACAAAAAA=="
]

invoke_host_function_op = InvokeHostFunction.set_auth(invoke_host_function_op, auth)
min_resource_fee = 68_996
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

### With Stellar Account Authorization

> **Note**
> Used when the tx submitter is different from the invoker.

```elixir
alias StellarBase.XDR.{SorobanResources, SorobanTransactionData, UInt32}

alias Stellar.TxBuild.{
  Account,
  BaseFee,
  InvokeContractArgs,
  InvokeHostFunction,
  HostFunction,
  SCVal,
  SCAddress,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

server = Stellar.Horizon.Server.new()
contract_address = SCAddress.new("CAMGSYINVVL6WP3Q5WPNL7FS4GZP37TWV7MKIRQF5QMYLK3N2SW4P3RC")

function_name = "inc"

## invoker
{invoker_public_key, invoker_secret_key} = KeyPair.from_secret_seed("SCA...3EK")

## submitter
submitter_keypair =
  {submitter_public_key, _submitter_secret_key} = KeyPair.from_secret_seed("SDR...Q24")


address_type = SCAddress.new(invoker_public_key)
address = SCVal.new(address: address_type)

args =
  InvokeContractArgs.new(
    contract_address: contract_address,
    function_name: function_name,
    args: SCVec.new([address, SCVal.new(u128: %{hi: 0, lo: 2})])
  )

host_function = HostFunction.new(invoke_contract: args)

invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)

source_account = Account.new(submitter_public_key)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(server, submitter_public_key)
sequence_number = SequenceNumber.new(seq_num)
signature = Signature.new(submitter_keypair)

# Use this XDR to simulate the transaction and get the soroban_data, the invoke_host_function auth and the min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
{%StellarBase.XDR.SorobanTransactionData{
   resources: %SorobanResources{instructions: %UInt32{datum: datum}} = resources
 } = soroban_data,
 ""} =
  "AAAAAAAAAAIAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAAB4w32Y19ZRfshxeO+Nw4BNSkE0ZhibcEWId4SVzs0PZPAAAAAgAAAAYAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAAFQ68kGSYE4XvAAAAAAAAAAYAAAABCYz5KO4roQUbbGNGg0NhIp4paZo/6w8hnbP6sebHkjQAAAAUAAAAAQBRdfwAABl8AAABcAAAAAAAAAwE"
|> Base.decode64!()
|> SorobanTransactionData.decode_xdr!()

# Use the Soroban RPC `getLatestLedger` endpoint to obtain this number.
# This number needs to be in the same ledger when submitting the transaction, otherwise the function invocation will fail.
latest_ledger = 164_265

auth_xdr = "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYOvJBkmBOF7wAAAAAAAAABAAAAAAAAAAEJjPko7iuhBRtsY0aDQ2Einilpmj/rDyGds/qx5seSNAAAAANpbmMAAAAAAgAAABIAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAACQAAAAAAAAAAAAAAAAAAAAIAAAAA"

auth = SorobanAuthorizationEntry.sign_xdr(auth_xdr, invoker_secret_key, latest_ledger)
invoke_host_function_op = InvokeHostFunction.set_auth(invoke_host_function_op, [auth])

# Needed calculations since simulate_transaction returns soroban_data
# with wrong calculated instructions value because there are two signers
new_instructions = UInt32.new(datum + round(datum * 0.25))
new_resources = %{resources | instructions: new_instructions}
soroban_data = %{soroban_data | resources: new_resources}

# `round(min_resource_fee*0.2)` is needed since the cost of the transaction will increase because there are two signers.
fee = BaseFee.new(min_resource_fee + round(min_resource_fee*0.2) +100)

# Use the XDR generated here to send it to the futurenet
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.set_base_fee(fee)
|> Stellar.TxBuild.set_soroban_data(soroban_data)
|> Stellar.TxBuild.sign(signature)
|> Stellar.TxBuild.envelope()

```
