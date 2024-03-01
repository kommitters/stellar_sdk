defmodule Stellar.TxBuild.TransactionSignatureTest do
  use ExUnit.Case

  alias Stellar.{KeyPair, Network}

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
        preconditions: Preconditions.new([]),
        memo: Memo.new(:none),
        operations: Operations.new([op])
      )

    tx_xdr = Transaction.to_xdr(tx)

    base_signature =
      <<221, 149, 123, 171, 23, 103, 0, 36, 251, 93, 218, 51, 151, 37, 43, 98, 224, 206, 210, 221,
        3, 94, 94, 67, 103, 51, 109, 194, 187, 158, 45, 212>>

    signature = Signature.new(keypair1)
    signature2 = Signature.new(keypair2)

    network_passphrase = Network.testnet_passphrase()
    tx_envelope = TransactionEnvelope.new(tx: tx, signatures: [signature], network_passphrase: network_passphrase)

    %{
      tx: tx,
      tx_xdr: tx_xdr,
      tx_envelope: tx_envelope,
      base_signature: base_signature,
      network_passphrase: network_passphrase,
      decorated_signature: Signature.to_xdr(signature, base_signature),
      signatures: [signature, signature2]
    }
  end

  test "sign/3", %{tx: tx, signatures: signatures, decorated_signature: decorated_signature, network_passphrase: network_passphrase} do
    %DecoratedSignatures{signatures: [^decorated_signature | _signatures]} =
      TransactionSignature.sign(tx, signatures, network_passphrase)
  end

  test "sign_xdr/3", %{
    tx_envelope: tx_envelope,
    signatures: [_signature, extra_signature],
    network_passphrase: network_passphrase
  } do
    %DecoratedSignatures{
      signatures: [
        _signature,
        %DecoratedSignature{hint: %SignatureHint{hint: <<243, 78, 123, 134>>}}
      ]
    } =
      tx_envelope
      |> TransactionEnvelope.to_xdr()
      |> TransactionSignature.sign_xdr(extra_signature, network_passphrase)
  end

  test "base_signature/2", %{
    tx_xdr: tx_xdr,
    network_passphrase: network_passphrase,
    base_signature: base_signature
  } do
    ^base_signature = TransactionSignature.base_signature(tx_xdr, network_passphrase)
  end
end
