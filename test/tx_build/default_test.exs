defmodule Stellar.TxBuild.DefaultTest do
  use ExUnit.Case

  alias Stellar.{KeyPair, TxBuild}

  alias Stellar.TxBuild.{
    Account,
    CreateAccount,
    Memo,
    Operation,
    Operations,
    Payment,
    Signature,
    Transaction,
    TransactionEnvelope,
    TimeBounds
  }

  setup do
    {public_key, secret} =
      keypair = KeyPair.from_secret_seed("SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z")

    signature = Signature.new({public_key, secret})
    account = Account.new("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS")
    tx = Transaction.new(account)

    %{
      account: account,
      keypair: keypair,
      signature: signature,
      tx: tx,
      tx_build: TxBuild.new(account),
      tx_envelope: TransactionEnvelope.new(tx, []),
      tx_envelope_base64:
        "AAAAAgAAAAD/rxPaN43ANPY6ITP1bWFqXRISJdEw+HkQpqrTxIRiTQAAAGQADqyoAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAABxIRiTQAAAECU7VvLeuntfRiJCTGesLDUPwt1TimPBEhjCBhmxSnjuxd63ubjGT+8c9ec6uuAMC8WrT21WOx9MQSma6YIWaEB"
    }
  end

  test "new/2", %{account: account, tx: tx} do
    %TxBuild{tx: ^tx, signatures: [], tx_envelope: nil} = TxBuild.new(account)
  end

  test "add_memo/2", %{tx_build: tx_build} do
    memo = Memo.new(text: "hello")
    %TxBuild{tx: %Transaction{memo: ^memo}} = TxBuild.add_memo(tx_build, memo)
  end

  test "set_timeout/2", %{tx_build: tx_build} do
    timeout = TimeBounds.set_max_time(123_456_789)
    %TxBuild{tx: %Transaction{time_bounds: ^timeout}} = TxBuild.set_timeout(tx_build, timeout)
  end

  test "add_operation/2", %{tx_build: tx_build, keypair: {public_key, _secret}} do
    op_body = CreateAccount.new(destination: public_key, starting_balance: 1.5)
    operation = Operation.new(op_body)

    %TxBuild{tx: %Transaction{operations: %Operations{operations: [^operation]}}} =
      TxBuild.add_operation(tx_build, op_body)
  end

  test "add_operations/2", %{tx_build: tx_build, keypair: {public_key, _secret}} do
    op1 = CreateAccount.new(destination: public_key, starting_balance: 1.5)
    op2 = Payment.new(destination: public_key, asset: :native, amount: 100)
    operations = [Operation.new(op1), Operation.new(op2)]

    %TxBuild{tx: %Transaction{operations: %Operations{operations: ^operations}}} =
      TxBuild.add_operations(tx_build, [op1, op2])
  end

  test "sign/2", %{keypair: keypair, tx_build: tx_build} do
    signature = Signature.new(keypair)
    %TxBuild{signatures: [^signature | _signatures]} = TxBuild.sign(tx_build, signature)
  end

  test "sign/2 multiple", %{signature: signature, tx_build: tx_build} do
    {pk, sk} = KeyPair.random()
    signatures = [signature, Signature.new({pk, sk})]

    %TxBuild{signatures: ^signatures} = TxBuild.sign(tx_build, signatures)
  end

  test "build/1", %{tx_build: tx_build, tx_envelope: tx_envelope} do
    %TxBuild{tx_envelope: ^tx_envelope} = TxBuild.build(tx_build)
  end

  test "envelope/1", %{
    signature: signature,
    tx_build: tx_build,
    tx_envelope_base64: tx_envelope_base64
  } do
    ^tx_envelope_base64 =
      tx_build
      |> TxBuild.sign(signature)
      |> TxBuild.envelope()
  end
end
