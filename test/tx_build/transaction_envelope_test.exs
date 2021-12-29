defmodule Stellar.TxBuild.TransactionEnvelopeTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [transaction_envelope_xdr: 2]

  alias Stellar.TxBuild.{Account, Signature, Transaction, TransactionEnvelope}

  setup do
    public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    secret = "SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z"
    account = Account.new(public_key)
    tx = Transaction.new(account)
    signature = Signature.new({public_key, secret})
    signatures = [signature]

    %{
      tx: tx,
      signatures: signatures,
      tx_envelope: TransactionEnvelope.new(tx, signatures),
      tx_envelope_xdr: transaction_envelope_xdr(tx, signatures),
      tx_envelope_base64:
        "AAAAAgAAAAD/rxPaN43ANPY6ITP1bWFqXRISJdEw+HkQpqrTxIRiTQAAAGQADqyoAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAABxIRiTQAAAECU7VvLeuntfRiJCTGesLDUPwt1TimPBEhjCBhmxSnjuxd63ubjGT+8c9ec6uuAMC8WrT21WOx9MQSma6YIWaEB"
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
