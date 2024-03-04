defmodule Stellar.Horizon.Offers do
  @moduledoc """
  Exposes functions to interact with Offers in Horizon.

  You can:
  * Retrieve an offer.
  * List all offers.
  * List an offer's trades.

  Horizon API reference: https://developers.stellar.org/api/resources/offers/
  """

  alias Stellar.Horizon.{Collection, Error, Offer, Request, Trade, RequestParams, Server}

  @type server :: Server.t()
  @type offer_id :: String.t()
  @type options :: Keyword.t()
  @type resource :: Offer.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "offers"

  @doc """
  Retrieves information of a specific offer.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `offer_id`: The unique identifier for the offer.

  ## Examples

      iex> Offers.retrieve(Stellar.Horizon.Server.testnet(), 165563085)
      {:ok, %Offer{}}
  """
  @spec retrieve(server :: server(), offer_id :: offer_id()) :: response()
  def retrieve(server, offer_id) do
    server
    |> Request.new(:get, @endpoint, path: offer_id)
    |> Request.perform()
    |> Request.results(as: Offer)
  end

  @doc """
  Lists all currently open offers.

  ## Parameters:
    * `server`: The Horizon server to query.

  ## Options

    * `sponsor`: The account ID of the sponsor who is paying the reserves for all the offers included in the response.
    * `seller`: The account ID of the offer creator.
    * `selling_asset`: `:native` or `[code: "selling_asset_code", issuer: "selling_asset_issuer"]`.
    * `buying_asset`: `:native` or `[code: "buying_asset_code", issuer: "buying_asset_issuer"]`.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Offers.all(Stellar.Horizon.Server.testnet(), limit: 20, order: :asc)
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by sponsor
      iex> Offers.all(Stellar.Horizon.Server.testnet(), sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by seller
      iex> Offers.all(Stellar.Horizon.Server.testnet(), seller: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by selling_asset
      iex> Offers.all(
        Stellar.Horizon.Server.testnet(),
        selling_asset: [
          code: "TEST",
          issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
        ],
        limit: 20
      )
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by buying_asset
      iex> Offers.all(
        Stellar.Horizon.Server.testnet(),
        buying_asset: [
          code: "TEST",
          issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
        ],
        limit: 20
      )
      {:ok, %Collection{records: [%Offer{}, ...]}}
  """
  @spec all(server :: server(), options :: options()) :: response()
  def all(server, options \\ []) do
    selling_asset = RequestParams.build_assets_params(options, :selling_asset)
    buying_asset = RequestParams.build_assets_params(options, :buying_asset)

    params =
      options
      |> Keyword.merge(selling_asset)
      |> Keyword.merge(buying_asset)

    server
    |> Request.new(:get, @endpoint)
    |> Request.add_query(params, extra_params: allowed_query_options())
    |> Request.perform()
    |> Request.results(collection: {Offer, &all(server, &1)})
  end

  @doc """
  Lists all trades for a given offer.

  ## Parameters
    * `server`: The Horizon server to query.
    * `offer_id`: The unique identifier for the offer.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Offers.list_trades(Stellar.Horizon.Server.testnet(), 165563085, limit: 20)
      {:ok, %Collection{records: [%Trade{}, ...]}}
  """
  @spec list_trades(server :: server(), offer_id :: offer_id(), options :: options()) ::
          response()
  def list_trades(server, offer_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: offer_id, segment: "trades")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Trade, &list_trades(server, offer_id, &1)})
  end

  @spec allowed_query_options() :: list()
  defp allowed_query_options do
    [
      :sponsor,
      :seller,
      :selling_asset_type,
      :selling_asset_issuer,
      :selling_asset_code,
      :buying_asset_type,
      :buying_asset_issuer,
      :buying_asset_code
    ]
  end
end
