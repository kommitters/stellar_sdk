defmodule Stellar.TxBuild.OptionalString32 do
  @moduledoc """
  `OptionalString32` struct definition.
  """
  alias StellarBase.XDR.OptionalString32
  alias Stellar.TxBuild.String32

  @behaviour Stellar.TxBuild.XDR

  @type value :: String32.t() | nil

  @type t :: %__MODULE__{value: value()}

  defstruct [:value]

  @impl true
  def new(value \\ nil, opts \\ [])

  def new(%String32{} = value, _opts) do
    %__MODULE__{value: value}
  end

  def new(nil, _opts), do: %__MODULE__{value: nil}

  @impl true
  def to_xdr(%__MODULE__{value: nil}), do: OptionalString32.new()

  def to_xdr(%__MODULE__{value: value}) do
    value
    |> String32.to_xdr()
    |> OptionalString32.new()
  end
end
