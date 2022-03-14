defmodule Stellar.Horizon.Offers do
  @moduledoc """
  Exposes functions to interact with Offers in Horizon.

  You can:
  * Retrieve an offer.
  * List all offers.
  * List an offer's trades.

  Horizon API reference: https://developers.stellar.org/api/resources/offers/
  """

  alias Stellar.Horizon.{Collection, Error, Offer, Request, Trade}

  @type offer_id :: String.t()
  @type options :: Keyword.t()
  @type resource :: Offer.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "offers"

  @doc """
  Retrieves information of a specific offer.

  ## Parameters:
    * `offer_id`: The unique identifier for the offer.

  ## Examples

      iex> Offers.retrieve(165563085)
      {:ok, %Offer{}}
  """
  @spec retrieve(offer_id :: offer_id()) :: response()
  def retrieve(offer_id) do
    :get
    |> Request.new(@endpoint, path: offer_id)
    |> Request.perform()
    |> Request.results(&Offer.new(&1))
  end

  @doc """
  Lists all currently open offers.

  ## Options

    * `sponsor`: The account ID of the sponsor who is paying the reserves for all the offers included in the response.
    * `seller`: The account ID of the offer creator.
    * `selling_asset_type`: The type for the selling asset. Either `native`, `credit_alphanum4`, or `credit_alphanum12`.
    * `selling_asset_issuer`: The account ID of the selling asset’s issuer.
    * `selling_asset_code`: The code for the selling asset.
    * `buying_asset_type`: The type for the buying asset. Either `native`, `credit_alphanum4`, or `credit_alphanum12`.
    * `buying_asset_issuer`: The account ID of the buying asset’s issuer.
    * `buying_asset_code`: The code for the buying asset.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Offers.all(limit: 20, order: :asc)
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by sponsor
      iex> Offers.all(sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by seller
      iex> Offers.all(seller: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by selling_asset_issuer
      iex> Offers.all(selling_asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Offer{}, ...]}}

      # list by buying_asset_type and buying_asset_code
      iex> Offers.all(buying_asset_type: "credit_alphanum4", buying_asset_code: "TEST")
      {:ok, %Collection{records: [%Offer{}, ...]}}
  """
  @spec all(options :: options()) :: response()
  def all(options \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(options, extra_params: allowed_query_options())
    |> Request.perform()
    |> Request.results(&Collection.new({Offer, &1}))
  end

  @doc """
  Lists all trades for a given offer.

  ## Parameters
    * `offer_id`: The unique identifier for the offer.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Offers.list_trades(165563085, limit: 20)
      {:ok, %Collection{records: [%Trade{}, ...]}}
  """
  @spec list_trades(offer_id :: offer_id(), options :: options()) :: response()
  def list_trades(offer_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: offer_id, segment: "trades")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(&Collection.new({Trade, &1}))
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
