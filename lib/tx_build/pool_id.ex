defmodule Stellar.TxBuild.PoolID do
  @moduledoc """
  `PoolID` struct definition.
  """
  alias StellarBase.XDR.PoolID

  @behaviour Stellar.TxBuild.XDR

  @type pool_id :: String.t()

  @type t :: %__MODULE__{pool_id: pool_id()}

  defstruct [:pool_id]

  @impl true
  def new(pool_id, opts \\ [])

  def new(pool_id, _opts) when is_bitstring(pool_id) and byte_size(pool_id) == 64 do
    %__MODULE__{pool_id: pool_id}
  end

  def new(_pool_id, _opts), do: {:error, :invalid_pool_id}

  @impl true
  def to_xdr(%__MODULE__{pool_id: pool_id}) do
    pool_id
    |> (&:crypto.hash(:sha256, &1)).()
    |> PoolID.new()
  end
end
