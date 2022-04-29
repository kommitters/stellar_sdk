defmodule Stellar.TxBuild.BaseFee do
  @moduledoc """
  `BaseFee` struct definition.
  """
  alias StellarBase.XDR.UInt32

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{fee: non_neg_integer(), multiplier: non_neg_integer()}

  defstruct [:fee, multiplier: 0]

  @impl true
  def new(fee \\ nil, opts \\ [])
  def new(nil, _opts), do: %__MODULE__{fee: base_fee()}
  def new(fee, _opts) when is_integer(fee), do: %__MODULE__{fee: fee}
  def new(_fee, _opts), do: {:error, :invalid_fee}

  @impl true
  def to_xdr(%__MODULE__{fee: fee, multiplier: 0}), do: UInt32.new(fee)
  def to_xdr(%__MODULE__{fee: fee, multiplier: multiplier}), do: UInt32.new(fee * multiplier)

  @spec increment(base_fee :: t(), times :: non_neg_integer()) :: t()
  def increment(base_fee, times \\ 1)

  def increment(%__MODULE__{multiplier: multiplier} = base_fee, times)
      when is_integer(times) and times >= 0 do
    %{base_fee | multiplier: multiplier + times}
  end

  def increment(_base_fee, _times), do: {:error, :invalid_fee}

  @spec base_fee() :: non_neg_integer()
  defp base_fee, do: 100
end
