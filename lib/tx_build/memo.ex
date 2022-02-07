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
  def new(type \\ :none, opts \\ [])

  def new(:none, _value) do
    %__MODULE__{type: :MEMO_NONE, value: nil}
  end

  def new([text: value], _opts) when is_bitstring(value) and byte_size(value) < 28 do
    %__MODULE__{type: :MEMO_TEXT, value: value}
  end

  def new([id: value], _opts) when is_integer(value) do
    %__MODULE__{type: :MEMO_ID, value: value}
  end

  def new([hash: value], _opts) when is_bitstring(value) and byte_size(value) == 64 do
    %__MODULE__{type: :MEMO_HASH, value: value}
  end

  def new([return: value], _opts) when is_bitstring(value) and byte_size(value) == 64 do
    %__MODULE__{type: :MEMO_RETURN, value: value}
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
  defp memo_xdr_value(value, memo_type) when memo_type in [:MEMO_HASH, :MEMO_RETURN] do
    value
    |> String.upcase()
    |> Base.decode16!()
    |> Hash.new()
  end

  defp memo_xdr_value(_value, :MEMO_NONE), do: nil
  defp memo_xdr_value(value, :MEMO_TEXT), do: String28.new(value)
  defp memo_xdr_value(value, :MEMO_ID), do: UInt64.new(value)
end
