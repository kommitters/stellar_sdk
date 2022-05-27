defmodule Stellar.TxBuild.Ledger.LiquidityPool do
  @moduledoc """
  Ledger `LiquidityPool` struct definition.
  """
  alias StellarBase.XDR.LiquidityPool
  alias Stellar.TxBuild.PoolID

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{liquidity_pool_id: PoolID.t()}

  defstruct [:liquidity_pool_id]

  @impl true
  def new(liquidity_pool_id, opts \\ [])

  def new(liquidity_pool_id, _opts) do
    case PoolID.new(liquidity_pool_id) do
      %PoolID{} = liquidity_pool_id -> %__MODULE__{liquidity_pool_id: liquidity_pool_id}
      error -> error
    end
  end

  @impl true
  def to_xdr(%__MODULE__{liquidity_pool_id: liquidity_pool_id}) do
    liquidity_pool_id
    |> PoolID.to_xdr()
    |> LiquidityPool.new()
  end
end
