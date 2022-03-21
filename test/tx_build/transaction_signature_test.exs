defmodule Stellar.TxBuild.TransactionSignatureTest do
  use ExUnit.Case

  alias Stellar.KeyPair

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
    TransactionEnvelope,
    TransactionSignature
  }

  alias StellarBase.XDR.{DecoratedSignature, DecoratedSignatures, SignatureHint}

  setup do
    {public_key, _secret} =
      keypair1 =
      KeyPair.from_secret_seed("SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z")

    keypair2 =
      KeyPair.from_secret_seed("SAALZGBDHMY5NQGU2L6G4GHQ65ESCDQD5TNYPWM5AZDVB3HICLKF4KI3")

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

    base_signature =
      <<171, 129, 177, 226, 243, 56, 134, 94, 61, 134, 123, 97, 244, 110, 78, 17, 231, 96, 32,
        172, 108, 36, 151, 24, 114, 216, 254, 26, 43, 36, 241, 118>>

    signature = Signature.new(keypair1)
    signature2 = Signature.new(keypair2)

    tx_envelope = TransactionEnvelope.new(tx, [signature])

    %{
      tx: tx,
      tx_envelope: tx_envelope,
      decorated_signature: Signature.to_xdr(signature, base_signature),
      signatures: [signature, signature2]
    }
  end

  test "sign/2", %{tx: tx, signatures: signatures, decorated_signature: decorated_signature} do
    %DecoratedSignatures{signatures: [^decorated_signature | _signatures]} =
      TransactionSignature.sign(tx, signatures)
  end

  test "sign_xdr/2", %{tx_envelope: tx_envelope, signatures: [_signature, extra_signature]} do
    %DecoratedSignatures{
      signatures: [
        _signature,
        %DecoratedSignature{hint: %SignatureHint{hint: <<243, 78, 123, 134>>}}
      ]
    } =
      tx_envelope
      |> TransactionEnvelope.to_xdr()
      |> TransactionSignature.sign_xdr(extra_signature)
  end
end
