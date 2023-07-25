# Invoke Contract Function
> **Warning**
> Please note that Soroban is still under development, so breaking changes may occur.

> **Note**
> All this actions require to use `simulateTransaction` and `sendTransaction` RPC endpoints when specified in the code comments to achieve the contract function invocation.

There are three ways to perform a contract function invocation:

### Without Contract Authorization

```elixir
alias Stellar.TxBuild.{
  Account,
  BaseFee,
  InvokeHostFunction,
  HostFunction,
  SCVal,
  SCVec,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

contract_address =
  "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV"
  |> SCAddress.new()
  |> (&SCVal.new(address: &1)).()
function_name = SCVal.new(symbol: "hello")
args = SCVec.new([contract_address, function_name, SCVal.new(string: "dev")])

host_function = HostFunction.new(invoke_contract: args)
invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)
keypair = {public_key, _secret} = Stellar.KeyPair.from_secret_seed("SDR...Q24")
source_account = Account.new(public_key)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)

signature = Signature.new(keypair)

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# simulate transaction
soroban_data =
  "AAAAAgAAAAZQma4vqEU8Njqacc34GYyiWNEvpEu13GiuAiVZX0YdNwAAABQAAAAHRhmB7Imi4CwJhmzp1r/d76UShPJrO5PSHOV2Z9tPbE8AAAAAABJ8KwAAE3AAAAAAAAAAAAAAAAAAAAAAAAAAAA=="

min_resource_fee = 51_470
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

```elixir
alias Stellar.TxBuild.{
  InvokeHostFunction,
  HostFunction,
  SCVal,
  SCVec,
  SCAddress,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

contract_address =
  "CD3HNKU3ERTEYLBBBVTSOYE4ZL2ZWV7NHLQIZRRKC4CBNMZXC7ISBXHV"
  |> SCAddress.new()
  |> (&SCVal.new(address: &1)).()
function_name = SCVal.new(symbol: "inc")
keypair = {public_key, _secret} = Stellar.KeyPair.from_secret_seed("SDR...Q24")
address_type = SCAddress.new(public_key)
address = SCVal.new(address: address_type)

args =
  SCVec.new([
    contract_address,
    function_name,
    address,
    SCVal.new(u128: %{hi: 0, lo: 2})
  ])

host_function = HostFunction.new(invoke_contract: args)
invoke_host_function_op = InvokeHostFunction.new(host_function: host_function)
source_account = Stellar.TxBuild.Account.new(public_key)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)
signature = Stellar.TxBuild.Signature.new(keypair)

# Use this XDR to simulate the transaction and get the soroban_data, the invoke_host_function auth
# and the min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
soroban_data =
  "AAAAAAAAAAEAAAAHmDXys1KuBimD87u2AiUG/jb5CqOkQW/qASpb6gMVRlsAAAAAAAAAAQAAAAYAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAAUAAAAAQAAAAAANnOcAAAUOAAAAQQAAAK8AAAAAAAAAIk="

auth = [
  "AAAAAAAAAAAAAAAB9naqmyRmTCwhDWcnYJzK9ZtX7TrgjMYqFwQWszcX0SAAAAADaW5jAAAAAAIAAAASAAAAAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAAkAAAAAAAAAAAAAAAAAAAACAAAAAA=="
]

invoke_host_function_op = InvokeHostFunction.set_auth(invoke_host_function_op, auth)
min_resource_fee = 78_281
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

### With Stellar Account Authorization (WIP: Preview 10 support)

```elixir
alias StellarBase.XDR.{SorobanResources, SorobanTransactionData, UInt32}

alias Stellar.TxBuild.{
  ContractAuth,
  AddressWithNonce,
  AuthorizedInvocation,
  BaseFee,
  InvokeHostFunction,
  HostFunction,
  HostFunctionArgs,
  SCVal,
  SCAddress,
  SequenceNumber,
  Signature
}

alias Stellar.Horizon.Accounts
alias Stellar.KeyPair

contract_id = "8367a1324fdbb56d41e6a6cea2364e389e9f4e17d3ebea810d7bdeca663c2cd5"
function_name = "inc"

## invoker
{public_key, secret_key} =
  KeyPair.from_secret_seed("SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK")

## submitter
keypair2 =
  {public_key_2, _secret_key_2} =
  KeyPair.from_secret_seed("SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24")

address_type = SCAddress.new(public_key)
address = SCVal.new(address: address_type)
args = [address, SCVal.new(u128: %{hi: 0, lo: 2})]

function_args =
  HostFunctionArgs.new(
    type: :invoke,
    contract_id: contract_id,
    function_name: function_name,
    args: args
  )

auth_invocation =
  AuthorizedInvocation.new(
    contract_id: contract_id,
    function_name: function_name,
    args: args,
    sub_invocations: []
  )

# Nonce increment by 1 each successfully contract call
address_with_nonce = AddressWithNonce.new(address: address_type, nonce: 0)

contract_auth =
  ContractAuth.new(
    address_with_nonce: address_with_nonce,
    authorized_invocation: auth_invocation
  )
  |> ContractAuth.sign(secret_key)

function = HostFunction.new(args: function_args, auth: [contract_auth])

invoke_host_function_op =
  InvokeHostFunction.new(functions: [function], source_account: public_key_2)

source_account = Stellar.TxBuild.Account.new(public_key_2)
{:ok, seq_num} = Accounts.fetch_next_sequence_number(public_key)
sequence_number = SequenceNumber.new(seq_num)
signature = Stellar.TxBuild.Signature.new(keypair2)

# Use this XDR to simulate the transaction and get the soroban_data and min_resource_fee
source_account
|> Stellar.TxBuild.new(sequence_number: sequence_number)
|> Stellar.TxBuild.add_operation(invoke_host_function_op)
|> Stellar.TxBuild.envelope()

# Simulate Transaction
{%StellarBase.XDR.SorobanTransactionData{
   resources: %SorobanResources{instructions: %UInt32{datum: datum}} = resources
 } = soroban_data,
 ""} =
  "AAAAAwAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAGg2ehMk/btW1B5qbOojZOOJ6fThfT6+qBDXveymY8LNUAAAAUAAAAB0YZgeyJouAsCYZs6da/3e+lEoTyazuT0hzldmfbT2xPAAAAAgAAAAaDZ6EyT9u1bUHmps6iNk44np9OF9Pr6oENe97KZjws1QAAABAAAAABAAAAAgAAAA8AAAAHQ291bnRlcgAAAAATAAAAAAAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gAAAAaDZ6EyT9u1bUHmps6iNk44np9OF9Pr6oENe97KZjws1QAAABUAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WABQR1AAAFLAAAAGoAAACZAAAAAAAAAB4AAAAAA=="
|> Base.decode64!()
|> SorobanTransactionData.decode_xdr!()

# Needed calculations since simulate_transaction returns soroban_data
# with wrong calculated instructions value because there are two signers
new_instructions = UInt32.new(datum + round(datum * 0.25))
new_resources = %{resources | instructions: new_instructions}
soroban_data = %{soroban_data | resources: new_resources}

# Arbitrary additional fee(10_000)
min_resource_fee = 97_397 + 10_000
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
