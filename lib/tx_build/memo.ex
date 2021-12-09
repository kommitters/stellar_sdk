defmodule Stellar.TxBuild.Memo do
  @moduledoc """
  `Memo` struct definition.
  """
  alias StellarBase.XDR.{UInt64, Hash, String28, MemoType, Memo}

  @behaviour Stellar.TxBuild.XDR

  @type memo_value :: String.t() | integer() | binary() | nil

  @type xdr_memo_value :: String28.t() | UInt64.t() | Hash.t() | nil

  @type t :: %__MODULE__{type: atom(), value: memo_value()}

  defstruct [:type, :value]

  @impl true
  def new(type \\ :none, value \\ nil)

  def new(:text, value) when is_bitstring(value) and byte_size(value) < 28 do
    %__MODULE__{type: :MEMO_TEXT, value: value}
  end

  def new(:id, value) when is_integer(value) do
    %__MODULE__{type: :MEMO_ID, value: value}
  end

  def new(:hash, value) when is_binary(value) do
    %__MODULE__{type: :MEMO_HASH, value: value}
  end

  def new(:return, value) when is_binary(value) do
    %__MODULE__{type: :MEMO_RETURN, value: value}
  end

  def new(:none, _value) do
    %__MODULE__{type: :MEMO_NONE, value: nil}
  end

  def new(_type, _value), do: {:error, :invalid_memo}

  @impl true
  def to_xdr(%__MODULE__{type: type, value: value}) do
    memo_type = MemoType.new(type)

    value
    |> memo_xdr_value(type)
    |> Memo.new(memo_type)
  end

  @spec memo_xdr_value(value :: memo_value(), type :: atom()) :: xdr_memo_value()
  defp memo_xdr_value(_value, :MEMO_NONE), do: nil
  defp memo_xdr_value(value, :MEMO_TEXT), do: String28.new(value)
  defp memo_xdr_value(value, :MEMO_ID), do: UInt64.new(value)
  defp memo_xdr_value(value, :MEMO_HASH), do: Hash.new(value)
  defp memo_xdr_value(value, :MEMO_RETURN), do: Hash.new(value)
end
