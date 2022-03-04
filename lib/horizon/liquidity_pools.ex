defmodule Stellar.Horizon.LiquidityPools do
  @moduledoc """
  Exposes functions to interact with LiquidityPools in Horizon.

  You can:
  * Retrieve a liquidity pool.
  * List all liquidity pools.
  * List a liquidity pool's effects.
  * List a liquidity pool's trades.
  * List a liquidity pool's transactions.
  * List a liquidity pool's operations.

  Horizon API reference: https://developers.stellar.org/api/resources/liquiditypools/
  """

  alias Stellar.Horizon.{
    Collection,
    Effect,
    Error,
    LiquidityPool,
    Operation,
    Request,
    Trade,
    Transaction
  }

  @type liquidity_pool_id :: String.t()
  @type params :: Keyword.t()
  @type resource :: LiquidityPool.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "liquidity_pools"

  @spec retrieve(liquidity_pool_id :: liquidity_pool_id()) :: response()
  def retrieve(liquidity_pool_id) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id)
    |> Request.perform()
    |> Request.results(&LiquidityPool.new(&1))
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: [:reserves, :account])
    |> Request.perform()
    |> Request.results(&Collection.new({LiquidityPool, &1}))
  end

  @spec list_effects(liquidity_pool_id :: liquidity_pool_id(), params :: params()) :: response()
  def list_effects(liquidity_pool_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "effects")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Effect, &1}))
  end

  @spec list_trades(liquidity_pool_id :: liquidity_pool_id(), params :: params()) :: response()
  def list_trades(liquidity_pool_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "trades")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Trade, &1}))
  end

  @spec list_transactions(liquidity_pool_id :: liquidity_pool_id(), params :: params()) ::
          response()
  def list_transactions(liquidity_pool_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "transactions")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Transaction, &1}))
  end

  @spec list_operations(liquidity_pool_id :: liquidity_pool_id(), params :: params()) ::
          response()
  def list_operations(liquidity_pool_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "operations")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end
end
