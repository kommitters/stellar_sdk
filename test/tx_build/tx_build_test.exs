defmodule Stellar.TxBuildTest do
  use ExUnit.Case

  alias Stellar.{KeyPair, TxBuild}

  alias Stellar.TxBuild.{
    Account,
    CreateAccount,
    Memo,
    Operation,
    Operations,
    Signature,
    Transaction,
    TransactionEnvelope,
    TimeBounds
  }

  setup do
    keypair = KeyPair.from_secret("SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z")
    public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    account = Account.new(public_key)
    tx = Transaction.new(account)

    %{
      account: account,
      keypair: keypair,
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
    memo = Memo.new(:text, "hello")
    %TxBuild{tx: %Transaction{memo: ^memo}} = TxBuild.add_memo(tx_build, memo)
  end

  test "set_timeout/2", %{tx_build: tx_build} do
    timeout = TimeBounds.set_max_time(123_456_789)
    %TxBuild{tx: %Transaction{time_bounds: ^timeout}} = TxBuild.set_timeout(tx_build, 123_456_789)
  end

  test "add_operation/2", %{tx_build: tx_build, keypair: {public_key, _secret}} do
    op_body = CreateAccount.new(public_key, 1.5)
    operation = Operation.new(op_body)

    %TxBuild{tx: %Transaction{operations: %Operations{operations: [^operation]}}} =
      TxBuild.add_operation(tx_build, op_body)
  end

  test "add_operation/2 multiple", %{tx_build: tx_build, keypair: {public_key, _secret}} do
    op1 = CreateAccount.new(public_key, 1.5)
    op2 = CreateAccount.new(public_key, 100)
    operations = [Operation.new(op1), Operation.new(op2)]

    %TxBuild{tx: %Transaction{operations: %Operations{operations: ^operations}}} =
      TxBuild.add_operation(tx_build, [op1, op2])
  end

  test "sign/2", %{keypair: {public_key, secret} = keypair, tx_build: tx_build} do
    signature = Signature.new(public_key, secret)
    %TxBuild{signatures: [^signature | _signatures]} = TxBuild.sign(tx_build, keypair)
  end

  test "sign/2 multiple", %{keypair: keypair1, tx_build: tx_build} do
    {pk1, sk1} = keypair1
    {pk2, sk2} = keypair2 = KeyPair.random()
    signatures = [Signature.new(pk1, sk1), Signature.new(pk2, sk2)]

    %TxBuild{signatures: ^signatures} = TxBuild.sign(tx_build, [keypair1, keypair2])
  end

  test "build/1", %{tx_build: tx_build, tx_envelope: tx_envelope} do
    %TxBuild{tx_envelope: ^tx_envelope} = TxBuild.build(tx_build)
  end

  test "envelope/1", %{
    keypair: keypair,
    tx_build: tx_build,
    tx_envelope_base64: tx_envelope_base64
  } do
    ^tx_envelope_base64 =
      tx_build
      |> TxBuild.sign(keypair)
      |> TxBuild.envelope()
  end
end
