defmodule Stellar.TxBuild.Amount do
  @moduledoc """
  `Amount` struct definition.
  """
  alias StellarBase.XDR.Int64

  @behaviour Stellar.TxBuild.XDR

  @unit 10_000_000

  @type amount :: non_neg_integer() | float()

  @type t :: %__MODULE__{amount: amount(), raw_amount: non_neg_integer()}

  defstruct [:amount, :raw_amount]

  @impl true
  def new(amount, opts \\ [])

  def new(amount, _opts) when is_integer(amount) and amount > 0 do
    %__MODULE__{amount: amount, raw_amount: amount * @unit}
  end

  def new(amount, _opts) when is_float(amount) and amount > 0 do
    %__MODULE__{amount: amount, raw_amount: trunc(amount * @unit)}
  end

  def new(_amount, _opts), do: {:error, :invalid_amount}

  @impl true
  def to_xdr(%__MODULE__{raw_amount: raw_amount}) do
    Int64.new(raw_amount)
  end
end
