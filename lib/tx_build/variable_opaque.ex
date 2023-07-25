defmodule Stellar.TxBuild.VariableOpaque do
  @moduledoc """
  `VariableOpaque` struct definition.
  """
  alias StellarBase.XDR.VariableOpaque

  @behaviour Stellar.TxBuild.XDR

  @type value :: String.t()

  @type t :: %__MODULE__{value: value()}

  defstruct [:value]

  @impl true
  def new(value, opts \\ [])

  def new(value, _opts) when is_binary(value), do: %__MODULE__{value: value}

  def new(_value, _opts), do: {:error, :invalid_opaque}

  @impl true
  def to_xdr(%__MODULE__{value: value}), do: VariableOpaque.new(value)
  def to_xdr(_struct), do: {:error, :invalid_struct}
end
