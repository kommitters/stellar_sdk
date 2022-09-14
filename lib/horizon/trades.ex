defmodule Stellar.Horizon.Trades do
  @moduledoc """
  Exposes functions to interact with Trades in Horizon.

  You can:
  * List all trades.

  Horizon API reference: https://developers.stellar.org/api/resources/trades/
  """

  alias Stellar.Horizon.{Collection, Error, Request, Trade, RequestParams}

  @type options :: Keyword.t()
  @type resource :: Trade.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "trades"

  @doc """
  Lists all trades.

  ## Options

    * `offer_id`: The offer ID. Used to filter for trades originating from a specific offer.
    * `base_asset_type`: The type for the base asset. Either `native`, `credit_alphanum4`, or `credit_alphanum12`.
    * `base_asset_issuer`: The account ID of the base asset’s issuer.
    * `base_asset_code`: The code for the base asset.
    * `counter_asset_type`: The type for the counter asset. Either `native`, `credit_alphanum4`, or `credit_alphanum12`.
    * `counter_asset_issuer`: The account ID of the counter asset’s issuer.
    * `counter_asset_code`: The code for the counter asset.
    * `trade_type`: Can be set to `all`, `orderbook`, or `liquidity_pools` to filter only trades executed across a given mechanism.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Trades.all(limit: 20, order: :asc)
      {:ok, %Collection{records: [%Trade{}, ...]}}

      # list by offer_id
      iex> Trades.all(offer_id: 165563085)
      {:ok, %Collection{records: [%Trade{}, ...]}}

      # list by base_asset_type and base_asset_code
      iex> Trades.all(base_asset_type: "credit_alphanum4", base_asset_code: "TEST")
      {:ok, %Collection{records: [%Trade{}, ...]}}

      # list by counter_asset_issuer
      iex> Trades.all(counter_asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Trade{}, ...]}}

      # list by trade_type
      iex> Trades.all(trade_type: "liquidity_pools", limit: 20)
      {:ok, %Collection{records: [%Trade{}, ...]}}
  """
  @spec all(options :: options()) :: response()
  def all(options \\ []) do
    base_asset = RequestParams.build_assets_params(options, :base_asset)
    counter_asset = RequestParams.build_assets_params(options, :counter_asset)

    params =
      options
      |> Keyword.take([:limit])
      |> Keyword.merge(base_asset)
      |> Keyword.merge(counter_asset)

    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: allowed_query_options())
    |> Request.perform()
    |> Request.results(collection: {Trade, &all/1})
  end

  @spec allowed_query_options() :: list()
  defp allowed_query_options do
    [
      :offer_id,
      :base_asset_type,
      :base_asset_issuer,
      :base_asset_code,
      :counter_asset_type,
      :counter_asset_issuer,
      :counter_asset_code,
      :trade_type
    ]
  end
end
