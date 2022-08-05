defmodule Stellar.TxBuild.TransactionEnvelopeTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.KeyPair

  alias Stellar.TxBuild.{
    Account,
    BaseFee,
    CreateAccount,
    Memo,
    Operation,
    Operations,
    Preconditions,
    SequenceNumber,
    Signature,
    Transaction,
    TransactionEnvelope
  }

  setup do
    public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    secret = "SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z"
    source_account = Account.new(public_key)

    op =
      [destination: public_key, starting_balance: 1.5]
      |> CreateAccount.new()
      |> Operation.new()

    tx =
      Transaction.new(
        source_account: source_account,
        sequence_number: SequenceNumber.new(123_456),
        base_fee: BaseFee.new(500),
        preconditions: Preconditions.new([]),
        memo: Memo.new(:none),
        operations: Operations.new([op])
      )

    signature = Signature.new({public_key, secret})
    signatures = [signature]

    %{
      tx: tx,
      signatures: signatures,
      tx_envelope: TransactionEnvelope.new(tx, signatures),
      tx_envelope_xdr: XDRFixtures.transaction_envelope(),
      tx_envelope_base64:
        "AAAAAgAAAAD/rxPaN43ANPY6ITP1bWFqXRISJdEw+HkQpqrTxIRiTQAAAfQAAAAAAAHiQAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAP+vE9o3jcA09johM/VtYWpdEhIl0TD4eRCmqtPEhGJNAAAAAADk4cAAAAAAAAAAAcSEYk0AAABA4XBteCIyqJn86GK0xMYA6h2lweeWfo0DNRY+rwiVGlAQyZkV+tYUbR0KmJMzScPRqMX7eEyDdOIMd7IkuEpNAQ=="
    }
  end

  test "new/2", %{tx: tx, signatures: signatures} do
    %TransactionEnvelope{tx: ^tx, signatures: ^signatures} =
      TransactionEnvelope.new(tx, signatures)
  end

  test "to_xdr/1", %{tx_envelope: tx_envelope, tx_envelope_xdr: tx_envelope_xdr} do
    ^tx_envelope_xdr = TransactionEnvelope.to_xdr(tx_envelope)
  end

  test "to_base64/1", %{tx_envelope: tx_envelope, tx_envelope_base64: tx_envelope_base64} do
    ^tx_envelope_base64 =
      tx_envelope
      |> TransactionEnvelope.to_xdr()
      |> TransactionEnvelope.to_base64()
  end

  test "from_base64/1", %{tx_envelope_base64: tx_envelope_base64} do
    %StellarBase.XDR.TransactionEnvelope{} = TransactionEnvelope.from_base64(tx_envelope_base64)
  end

  test "from_base64/1 error" do
    assert_raise ArgumentError, fn -> TransactionEnvelope.from_base64("AAAAA==") end
  end

  test "add_signature/2", %{tx_envelope_base64: tx_envelope_base64} do
    secret_seed = "SAALZGBDHMY5NQGU2L6G4GHQ65ESCDQD5TNYPWM5AZDVB3HICLKF4KI3"

    extra_signature =
      secret_seed
      |> KeyPair.from_secret_seed()
      |> Signature.new()

    xdr = XDRFixtures.transaction_envelope(extra_signatures: [secret_seed])

    ^xdr = TransactionEnvelope.add_signature(tx_envelope_base64, extra_signature)
  end
end
