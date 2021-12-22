defmodule Stellar.TxBuild.Amount do
  @moduledoc """
  `Amount` struct definition.
  """
  alias StellarBase.XDR.Int64

  @behaviour Stellar.TxBuild.XDR

  @unit 10_000_000
  @max_size 9_223_372_036_854_775_807

  @type amount :: non_neg_integer() | float()

  @type t :: %__MODULE__{amount: amount(), raw: non_neg_integer()}

  defstruct [:amount, :raw]

  @impl true
  def new(amount, opts \\ [])

  def new(:max, _opts) do
    %__MODULE__{amount: @max_size / @unit, raw: @max_size}
  end

  def new(amount, _opts) when is_number(amount) and amount >= 0 and amount <= @max_size do
    %__MODULE__{amount: amount, raw: trunc(amount * @unit)}
  end

  def new(_amount, _opts), do: {:error, :invalid_amount}

  @impl true
  def to_xdr(%__MODULE__{raw: raw}) do
    Int64.new(raw)
  end
end
