defmodule Stellar.TxBuild.OptionalWeight do
  @moduledoc """
  `OptionalWeight` struct definition.
  """
  alias StellarBase.XDR.OptionalUInt32
  alias Stellar.TxBuild.Weight

  @behaviour Stellar.TxBuild.XDR

  @type weight :: Weight.t() | nil

  @type t :: %__MODULE__{weight: weight()}

  defstruct [:weight]

  @impl true
  def new(weight \\ nil, opts \\ [])

  def new(%Weight{} = weight, _opts) do
    %__MODULE__{weight: weight}
  end

  def new(nil, _opts), do: %__MODULE__{weight: nil}

  @impl true
  def to_xdr(%__MODULE__{weight: nil}), do: OptionalUInt32.new()

  def to_xdr(%__MODULE__{weight: weight}) do
    weight
    |> Weight.to_xdr()
    |> OptionalUInt32.new()
  end
end
