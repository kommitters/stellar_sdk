alias Stellar.TxBuild.{InvokeHostFunction, HostFunction, SCVal, SCStatus}

contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
function_name = "hello"
args = [SCVal.new(symbol: "world")]

#when is SCVal is SCStatus
SCStatus.new(host_value_error: :HOST_VALUE_UNKNOWN_ERROR)
SCStatus.new(ok: nil)
SCStatus.new(host_auth_error: :HOST_AUTH_DUPLICATE_AUTHORIZATION)
SCStatus.new(host_auth_error: :duplicate_authorization)

function = HostFunction.new(
  type: :invoke,
  contract_id: contract_id,
  function_name: function_name,
  args: args
)

invoke_host_function_op = InvokeHostFunction.new(function: function)


keypair = {public_key, _secret} = Stellar.KeyPair.from_secret_seed("SBXXZLTEXYMRYRV7FUE7ZZBPCEIT5IJKUJOZ5MWDUXX7474H7ACOJND7")

source_account = Stellar.TxBuild.Account.new(public_key)

{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(public_key)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)


signature = Stellar.TxBuild.Signature.new(keypair)


{:ok, envelope_simulate} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(invoke_host_function_op)
  |> Stellar.TxBuild.envelope()


# simulate transaction...

footprint = "AAAAAgAAAAYEYRaMu64NqWxUO3H9VxrsS0RUnVA/mvnnaFzO28FhPAAAAAMAAAADAAAAB333b6x0UKU606981VsXWEBukqHf/ofD44TsB48KjKRLAAAAAA=="
invoke_host_function_op = InvokeHostFunction.set_footprint(invoke_host_function_op, footprint)

{:ok, seq_num} = Stellar.Horizon.Accounts.fetch_next_sequence_number(public_key)
sequence_number = Stellar.TxBuild.SequenceNumber.new(seq_num)

{:ok, envelope_transaction} =
  source_account
  |> Stellar.TxBuild.new(sequence_number: sequence_number)
  |> Stellar.TxBuild.add_operation(invoke_host_function_op)
  |> Stellar.TxBuild.sign(signature)
  |> Stellar.TxBuild.envelope()


{:ok, submitted_tx} = Stellar.Horizon.Transactions.create(base64_envelope)
