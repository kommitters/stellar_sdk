defmodule Stellar.TxBuild.TransactionSignatureTest do
  use ExUnit.Case

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
    TransactionSignature
  }

  alias StellarBase.XDR.DecoratedSignatures

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

    base_signature =
      <<171, 129, 177, 226, 243, 56, 134, 94, 61, 134, 123, 97, 244, 110, 78, 17, 231, 96, 32,
        172, 108, 36, 151, 24, 114, 216, 254, 26, 43, 36, 241, 118>>

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
