defmodule Stellar.TxBuildTest do
  use ExUnit.Case

  alias Stellar.{KeyPair, TxBuild}

  alias Stellar.TxBuild.{
    Account,
    Memo,
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

  @tag :pending
  test "add_operation/2", %{tx_build: tx_build} do
    %TxBuild{tx: %Transaction{operations: %Operations{operations: [:payment]}}} =
      TxBuild.add_operation(tx_build, :payment)
  end

  test "sign/2", %{keypair: {public_key, secret} = keypair, tx_build: tx_build} do
    signature = Signature.new(public_key, secret)
    %TxBuild{signatures: [^signature | _signatures]} = TxBuild.sign(tx_build, keypair)
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
