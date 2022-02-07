defmodule Stellar.TxBuild.String32 do
  @moduledoc """
  `String32` struct definition.
  """
  alias StellarBase.XDR.{String32, String32}

  @behaviour Stellar.TxBuild.XDR

  @type value :: String.t()

  @type t :: %__MODULE__{value: value()}

  defstruct [:value]

  @max_length 32

  @impl true
  def new(value, opts \\ [])

  def new(value, _opts) when is_bitstring(value) and byte_size(value) <= @max_length do
    %__MODULE__{value: value}
  end

  def new(_value, _opts), do: {:error, :invalid_string}

  @impl true
  def to_xdr(%__MODULE__{value: value}) do
    String32.new(value)
  end
end
