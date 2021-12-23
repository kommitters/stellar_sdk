defmodule Stellar.TxBuild.TransactionSignatureTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Account, Signature, Transaction, TransactionSignature}
  alias StellarBase.XDR.DecoratedSignatures

  setup do
    public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    secret = "SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z"

    tx =
      public_key
      |> Account.new()
      |> Transaction.new()

    base_signature =
      <<221, 182, 124, 1, 170, 219, 95, 188, 245, 30, 147, 123, 228, 111, 20, 56, 22, 55, 101, 74,
        206, 105, 230, 184, 209, 120, 244, 158, 120, 75, 183, 37>>

    signature = Signature.new({public_key, secret})

    %{
      tx: tx,
      decorated_signature: Signature.to_xdr(signature, base_signature),
      signatures: [signature]
    }
  end

  test "sign/2", %{tx: tx, signatures: signatures, decorated_signature: decorated_signature} do
    %DecoratedSignatures{signatures: [^decorated_signature | _signatures]} =
      TransactionSignature.sign(tx, signatures)
  end
end
