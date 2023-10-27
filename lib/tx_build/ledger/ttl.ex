defmodule Stellar.TxBuild.Ledger.TTL do
  @moduledoc """
  Ledger `TTL` struct definition.
  """
  alias StellarBase.XDR.{Hash, LedgerKeyTTL}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{key_hash: binary()}

  defstruct [:key_hash]

  @impl true
  def new(key_hash, opts \\ [])

  def new(key_hash, _opts) when is_binary(key_hash), do: %__MODULE__{key_hash: key_hash}

  def new(_key_hash, _opts), do: {:error, :invalid_ttl}

  @impl true
  def to_xdr(%__MODULE__{key_hash: key_hash}) do
    key_hash
    |> Hash.new()
    |> LedgerKeyTTL.new()
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
