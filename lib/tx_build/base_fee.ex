defmodule Stellar.TxBuild.BaseFee do
  @moduledoc """
  `BaseFee` struct definition.
  """
  alias StellarBase.XDR.UInt32

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{fee: non_neg_integer(), multiplier: non_neg_integer()}

  defstruct [:fee, :multiplier]

  @impl true
  def new(fee \\ base_fee(), multiplier \\ 1)

  def new(fee, multiplier) when is_integer(fee) and is_integer(multiplier) do
    %__MODULE__{fee: fee, multiplier: multiplier}
  end

  def new(_fee, _multiplier), do: {:error, :invalid_fee}

  @impl true
  def to_xdr(%__MODULE__{fee: fee, multiplier: multiplier}) do
    UInt32.new(fee * multiplier)
  end

  @spec base_fee() :: non_neg_integer()
  defp base_fee, do: 100
end
