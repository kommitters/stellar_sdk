defmodule Stellar.TxBuild.Weight do
  @moduledoc """
  `Weight` struct definition.
  """
  alias StellarBase.XDR.UInt32

  @behaviour Stellar.TxBuild.XDR

  @type weight :: non_neg_integer()

  @type t :: %__MODULE__{value: weight()}

  defstruct [:value]

  @impl true
  def new(weight, opts \\ [])

  def new(weight, _opts) when is_integer(weight) and weight >= 0 and weight <= 255 do
    %__MODULE__{value: weight}
  end

  def new(_value, _opts), do: {:error, :invalid_weight}

  @impl true
  def to_xdr(%__MODULE__{value: weight}) do
    UInt32.new(weight)
  end
end
