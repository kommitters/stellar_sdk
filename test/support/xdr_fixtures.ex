defmodule Stellar.Test.XDRFixtures do
  @moduledoc """
  Stellar's XDR data for test constructions.
  """
  alias Stellar.KeyPair

  alias StellarBase.XDR.{
    CryptoKeyType,
    Ext,
    Hash,
    Memo,
    MemoType,
    MuxedAccount,
    Operations,
    OptionalTimeBounds,
    SequenceNumber,
    String28,
    Transaction,
    UInt32,
    UInt64,
    UInt256
  }

  @spec muxed_account_xdr(account_id :: String.t()) :: MuxedAccount.t()
  def muxed_account_xdr(account_id) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> MuxedAccount.new(type)
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

  @spec memo_xdr_value(value :: any(), type :: atom()) :: struct()
  defp memo_xdr_value(_value, :MEMO_NONE), do: nil
  defp memo_xdr_value(value, :MEMO_TEXT), do: String28.new(value)
  defp memo_xdr_value(value, :MEMO_ID), do: UInt64.new(value)
  defp memo_xdr_value(value, :MEMO_HASH), do: Hash.new(value)
  defp memo_xdr_value(value, :MEMO_RETURN), do: Hash.new(value)
end
