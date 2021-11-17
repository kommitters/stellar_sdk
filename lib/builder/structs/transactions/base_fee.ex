defmodule Stellar.Builder.Structs.BaseFee do
  @moduledoc """
  `BaseFee` struct definition.
  """
  alias StellarBase.XDR.UInt32

  @type t :: %__MODULE__{fee: non_neg_integer(), multiplier: non_neg_integer()}

  defstruct [:fee, :multiplier]

  @spec new(fee :: non_neg_integer(), multiplier :: non_neg_integer()) :: t()
  def new(fee \\ base_fee(), multiplier \\ 1) do
    %__MODULE__{fee: fee, multiplier: multiplier}
  end

  @spec to_xdr(base_fee :: t()) :: UInt32.t()
  def to_xdr(%__MODULE__{fee: fee, multiplier: multiplier}) do
    UInt32.new(fee * multiplier)
  end

  @spec base_fee() :: non_neg_integer()
  defp base_fee, do: 100
end
