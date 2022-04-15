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
  @type options :: Keyword.t()
  @type resource :: LiquidityPool.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "liquidity_pools"

  @doc """
  Retrieves information of a specific liquidity pool.

  ## Parameters:
    * `liquidity_pool_id`: A liquidity pool’s id encoded in a hex string representation.

  ## Examples

      iex> LiquidityPools.retrieve("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc")
      {:ok, %LiquidityPool{}}
  """
  @spec retrieve(liquidity_pool_id :: liquidity_pool_id()) :: response()
  def retrieve(liquidity_pool_id) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id)
    |> Request.perform()
    |> Request.results(as: LiquidityPool)
  end

  @doc """
  Lists all available claimable balances.

  ## Options

    * `reserves`: Comma-separated list of assets in canonical form “Code:IssuerAccountID”.
    * `account`: Account ID of the destination address.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> LiquidityPools.all(limit: 2, order: :asc)
      {:ok, %Collection{records: [%LiquidityPool{}, ...]}}

      # list by reserves
      iex> LiquidityPools.all(reserves: "TEST:GCXMW..., TEST2:GCXMW...")
      {:ok, %Collection{records: [%LiquidityPool{}, ...]}}

      # list by account
      iex> LiquidityPools.all(account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)
      {:ok, %Collection{records: [%LiquidityPool{}, ...]}}
  """
  @spec all(options :: options()) :: response()
  def all(options \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(options, extra_options: [:reserves, :account])
    |> Request.perform()
    |> Request.results(collection: {LiquidityPool, &all/1})
  end

  @doc """
  Lists the effects of a specific liquidity pool.

  ## Parameters
    * `liquidity_pool_id`: A liquidity pool’s id encoded in a hex string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> LiquidityPools.list_effects("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)
      {:ok, %Collection{records: [%Effect{}, ...]}}
  """
  @spec list_effects(liquidity_pool_id :: liquidity_pool_id(), options :: options()) :: response()
  def list_effects(liquidity_pool_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "effects")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Effect, &list_effects(liquidity_pool_id, &1)})
  end

  @doc """
  Lists the successful trades fulfilled by the given liquidity pool.

  ## Parameters
    * `liquidity_pool_id`: A liquidity pool’s id encoded in a hex string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> LiquidityPools.list_trades("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)
      {:ok, %Collection{records: [%Trade{}, ...]}}
  """
  @spec list_trades(liquidity_pool_id :: liquidity_pool_id(), options :: options()) :: response()
  def list_trades(liquidity_pool_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "trades")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Trade, &list_trades(liquidity_pool_id, &1)})
  end

  @doc """
  Lists successful transactions referencing a given liquidity pool.

  ## Parameters
    * `liquidity_pool_id`: A liquidity pool’s id encoded in a hex string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.

  ## Examples

      iex> LiquidityPools.list_transactions("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)
      {:ok, %Collection{records: [%Transaction{}, ...]}}
  """
  @spec list_transactions(liquidity_pool_id :: liquidity_pool_id(), options :: options()) ::
          response()
  def list_transactions(liquidity_pool_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "transactions")
    |> Request.add_query(options, extra_options: [:include_failed])
    |> Request.perform()
    |> Request.results(collection: {Transaction, &list_transactions(liquidity_pool_id, &1)})
  end

  @doc """
  Lists successful operations referencing a given liquidity pool.

  ## Parameters
    * `liquidity_pool_id`: A liquidity pool’s id encoded in a hex string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> LiquidityPools.list_operations("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", limit: 20)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # join transactions
      iex> LiquidityPools.list_operations("001365fc79ca661f31ba3ee0849ae4ba36f5c377243242d37fad5b1bb8912dbc", join: "transactions")
      {:ok, %Collection{records: [%Operation{transaction: %Transaction{}}, ...]}}
  """
  @spec list_operations(liquidity_pool_id :: liquidity_pool_id(), options :: options()) ::
          response()
  def list_operations(liquidity_pool_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: liquidity_pool_id, segment: "operations")
    |> Request.add_query(options, extra_options: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_operations(liquidity_pool_id, &1)})
  end
end
