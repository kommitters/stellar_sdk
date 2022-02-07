defmodule Stellar.TxBuild.TransactionEnvelopeTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [transaction_envelope_xdr: 2]

  alias Stellar.TxBuild.{
    Account,
    BaseFee,
    CreateAccount,
    Memo,
    Operation,
    Operations,
    SequenceNumber,
    Signature,
    TimeBounds,
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
        time_bounds: TimeBounds.new(:none),
        memo: Memo.new(:none),
        operations: Operations.new([op])
      )

    signature = Signature.new({public_key, secret})
    signatures = [signature]

    %{
      tx: tx,
      signatures: signatures,
      tx_envelope: TransactionEnvelope.new(tx, signatures),
      tx_envelope_xdr: transaction_envelope_xdr(tx, signatures),
      tx_envelope_base64:
        "AAAAAgAAAAD/rxPaN43ANPY6ITP1bWFqXRISJdEw+HkQpqrTxIRiTQAAw1AAAAAAAAHiQAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAP+vE9o3jcA09johM/VtYWpdEhIl0TD4eRCmqtPEhGJNAAAAAADk4cAAAAAAAAAAAcSEYk0AAABA/ZXTNzCemP6Mwb/SGIUGhFKk/w4VVurCsJf7td7LrConewwxkrQGNuaYODTVlqQFHNp8RhZQtI/i5lDQ5Z5qAQ=="
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
end
