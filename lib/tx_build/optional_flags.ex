defmodule Stellar.TxBuild.OptionalFlags do
  @moduledoc """
  `OptionalFlags` struct definition.
  """
  alias StellarBase.XDR.OptionalUInt32
  alias Stellar.TxBuild.Flags

  @behaviour Stellar.TxBuild.XDR

  @type flags :: Flags.t() | nil

  @type t :: %__MODULE__{flags: flags()}

  defstruct [:flags]

  @impl true
  def new(flags \\ nil, opts \\ [])

  def new(%Flags{} = flags, _opts) do
    %__MODULE__{flags: flags}
  end

  def new(nil, _opts), do: %__MODULE__{flags: nil}

  @impl true
  def to_xdr(%__MODULE__{flags: nil}), do: OptionalUInt32.new()

  def to_xdr(%__MODULE__{flags: flags}) do
    flags
    |> Flags.to_xdr()
    |> OptionalUInt32.new()
  end
end
