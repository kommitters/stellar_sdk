defmodule Stellar.Test.XDRFixtures do
  @moduledoc """
  Stellar's XDR data for test constructions.
  """
  alias Stellar.KeyPair
  alias Stellar.TxBuild.TransactionSignature
  alias Stellar.TxBuild.Transaction, as: Tx

  alias StellarBase.XDR.{
    AccountID,
    AlphaNum12,
    AlphaNum4,
    Asset,
    AssetCode4,
    AssetCode12,
    AssetType,
    CryptoKeyType,
    DecoratedSignature,
    EnvelopeType,
    Ext,
    Hash,
    Int64,
    Memo,
    MemoType,
    MuxedAccount,
    OperationType,
    OperationBody,
    Operation,
    Operations,
    OptionalMuxedAccount,
    OptionalTimeBounds,
    PublicKey,
    PublicKeyType,
    SequenceNumber,
    Signature,
    SignatureHint,
    String28,
    Transaction,
    TransactionV1Envelope,
    TransactionEnvelope,
    UInt32,
    UInt64,
    UInt256,
    Void
  }

  alias StellarBase.XDR.Operations.{CreateAccount, Payment}

  @unit 10_000_000

  @spec muxed_account_xdr(account_id :: String.t()) :: MuxedAccount.t()
  def muxed_account_xdr(account_id) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> MuxedAccount.new(type)
  end

  @spec account_id_xdr(public_key :: String.t()) :: MuxedAccount.t()
  def account_id_xdr(public_key) do
    type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)

    public_key
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> PublicKey.new(type)
    |> AccountID.new()
  end

  @spec memo_xdr(type :: atom(), value :: any()) :: Memo.t()
  def memo_xdr(type, value) do
    memo_type = MemoType.new(type)

    value
    |> memo_xdr_value(type)
    |> Memo.new(memo_type)
  end

  @spec transaction_xdr(account_id :: String.t()) :: Transaction.t()
  def transaction_xdr(account_id) do
    muxed_account = muxed_account_xdr(account_id)
    base_fee = UInt32.new(100)
    seq_number = SequenceNumber.new(4_130_487_228_432_385)
    time_bounds = OptionalTimeBounds.new(nil)
    memo_type = MemoType.new(:MEMO_NONE)
    memo = Memo.new(nil, memo_type)
    operations = Operations.new([])

    Transaction.new(
      muxed_account,
      base_fee,
      seq_number,
      time_bounds,
      memo,
      operations,
      Ext.new()
    )
  end

  @spec transaction_envelope_xdr(tx :: Tx.t(), signatures :: list(Signature.t())) ::
          TransactionEnvelope.t()
  def transaction_envelope_xdr(tx, signatures) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)
    decorated_signatures = TransactionSignature.sign(tx, signatures)

    tx
    |> Tx.to_xdr()
    |> TransactionV1Envelope.new(decorated_signatures)
    |> TransactionEnvelope.new(envelope_type)
  end

  @spec decorated_signature_xdr(raw_secret :: binary(), hint :: binary(), payload :: binary()) ::
          DecoratedSignature.t()
  def decorated_signature_xdr(raw_secret, hint, payload) do
    payload
    |> KeyPair.sign(raw_secret)
    |> decorated_signature_xdr(hint)
  end

  @spec decorated_signature_xdr(raw_secret :: binary(), hint :: binary()) ::
          DecoratedSignature.t()
  def decorated_signature_xdr(raw_secret, hint) do
    signature = Signature.new(raw_secret)

    hint
    |> SignatureHint.new()
    |> DecoratedSignature.new(signature)
  end

  @spec operation_xdr(op_body :: struct()) :: Operation.t()
  def operation_xdr(%OperationBody{} = op_body) do
    source_account = OptionalMuxedAccount.new(nil)
    Operation.new(op_body, source_account)
  end

  @spec create_account_op_xdr(destination :: String.t(), amount :: non_neg_integer()) ::
          CreateAccount.t()
  def create_account_op_xdr(destination, amount) do
    op_type = OperationType.new(:CREATE_ACCOUNT)
    amount = Int64.new(amount * @unit)

    destination
    |> account_id_xdr()
    |> CreateAccount.new(amount)
    |> OperationBody.new(op_type)
  end

  @spec create_payment_op_xdr(
          destination :: String.t(),
          asset :: tuple(),
          amount :: non_neg_integer()
        ) :: Payment.t()
  def create_payment_op_xdr(destination, {asset_code, asset_issuer}, amount) do
    op_type = OperationType.new(:PAYMENT)
    amount = Int64.new(amount * @unit)

    asset =
      if String.length(asset_code) > 4,
        do: create_asset12_xdr(asset_code, asset_issuer),
        else: create_asset4_xdr(asset_code, asset_issuer)

    destination
    |> muxed_account_xdr()
    |> Payment.new(asset, amount)
    |> OperationBody.new(op_type)
  end

  @spec create_asset_native_xdr() :: Asset.t()
  def create_asset_native_xdr do
    Asset.new(Void.new(), AssetType.new(:ASSET_TYPE_NATIVE))
  end

  @spec create_asset4_xdr(code :: String.t(), issuer :: String.t()) :: Asset.t()
  def create_asset4_xdr(code, issuer) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM4)
    issuer = account_id_xdr(issuer)

    code
    |> AssetCode4.new()
    |> AlphaNum4.new(issuer)
    |> Asset.new(asset_type)
  end

  @spec create_asset12_xdr(code :: String.t(), issuer :: String.t()) :: Asset.t()
  def create_asset12_xdr(code, issuer) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM12)
    issuer = account_id_xdr(issuer)

    code
    |> AssetCode12.new()
    |> AlphaNum12.new(issuer)
    |> Asset.new(asset_type)
  end

  @spec memo_xdr_value(value :: any(), type :: atom()) :: struct()
  defp memo_xdr_value(_value, :MEMO_NONE), do: nil
  defp memo_xdr_value(value, :MEMO_TEXT), do: String28.new(value)
  defp memo_xdr_value(value, :MEMO_ID), do: UInt64.new(value)
  defp memo_xdr_value(value, :MEMO_HASH), do: Hash.new(value)
  defp memo_xdr_value(value, :MEMO_RETURN), do: Hash.new(value)
end
