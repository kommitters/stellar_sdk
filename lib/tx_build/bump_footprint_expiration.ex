defmodule Stellar.TxBuild.BumpFootprintExpiration do
  @moduledoc """
  `BumpFootprintExpiration` struct definition.
  """

  alias StellarBase.XDR.{
    ExtensionPoint,
    Operations.BumpFootprintExpiration,
    UInt32,
    Void
  }

  @behaviour Stellar.TxBuild.XDR

  @type ledgers_to_expire :: integer()

  @type t :: %__MODULE__{ledgers_to_expire: ledgers_to_expire()}

  defstruct [:ledgers_to_expire]

  @impl true
  def new(ledgers_to_expire, opts \\ [])

  def new(ledgers_to_expire, _opts) when is_integer(ledgers_to_expire) do
    %__MODULE__{ledgers_to_expire: ledgers_to_expire}
  end

  def new(_value, _opts), do: {:error, :invalid_ledger}

  @impl true
  def to_xdr(%__MODULE__{ledgers_to_expire: ledgers_to_expire}) do
    ledgers_to_expire = UInt32.new(ledgers_to_expire)

    Void.new()
    |> ExtensionPoint.new(0)
    |> BumpFootprintExpiration.new(ledgers_to_expire)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
