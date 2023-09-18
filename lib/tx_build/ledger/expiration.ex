defmodule Stellar.TxBuild.Ledger.Expiration do
  @moduledoc """
  Ledger `Expiration` struct definition.
  """
  alias StellarBase.XDR.{Hash, LedgerKeyExpiration}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{key_hash: binary()}

  defstruct [:key_hash]

  @impl true
  def new(key_hash, opts \\ [])

  def new(key_hash, _opts) when is_binary(key_hash), do: %__MODULE__{key_hash: key_hash}

  def new(_key_hash, _opts), do: {:error, :invalid_expiration}

  @impl true
  def to_xdr(%__MODULE__{key_hash: key_hash}) do
    key_hash
    |> Hash.new()
    |> LedgerKeyExpiration.new()
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
