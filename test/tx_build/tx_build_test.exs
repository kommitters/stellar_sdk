defmodule Stellar.TxBuildTest do
  use ExUnit.Case

  alias Stellar.{KeyPair, TxBuild}
  alias Stellar.TxBuild.{Account, Memo, Operations, Transaction, TransactionEnvelope, TimeBounds}
  alias StellarBase.XDR.TransactionEnvelope, as: TxEnvelopeXDR

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    account = Account.new(account_id)
    tx = Transaction.new(account)

    %{
      account: account,
      tx: tx,
      tx_build: TxBuild.new(account),
      tx_envelope: TransactionEnvelope.new(tx, [])
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

  @tag :pending
  test "sign/2", %{tx_build: tx_build} do
    keypair = KeyPair.random()
    ^tx_build = TxBuild.sign(tx_build, keypair)
  end

  test "build/1", %{tx_build: tx_build, tx_envelope: tx_envelope} do
    tx_envelope_xdr = TransactionEnvelope.to_xdr(tx_envelope)
    ^tx_envelope_xdr = TxBuild.build(tx_build)
  end

  test "to_base64/1", %{tx_envelope: tx_envelope} do
    tx_envelope_xdr = TransactionEnvelope.to_xdr(tx_envelope)

    tx_envelope_base64 =
      tx_envelope_xdr
      |> TxEnvelopeXDR.encode_xdr!()
      |> Base.encode64()

    ^tx_envelope_base64 = TxBuild.to_base64(tx_envelope_xdr)
  end
end
