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
  @type params :: Keyword.t()
  @type resource :: Offer.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "offers"

  @spec retrieve(offer_id :: offer_id()) :: response()
  def retrieve(offer_id) do
    :get
    |> Request.new(@endpoint, path: offer_id)
    |> Request.perform()
    |> Request.results(&Offer.new(&1))
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: allowed_query_params())
    |> Request.perform()
    |> Request.results(&Collection.new({Offer, &1}))
  end

  @spec list_trades(offer_id :: offer_id(), params :: params()) :: response()
  def list_trades(offer_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: offer_id, segment: "trades")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Trade, &1}))
  end

  @spec allowed_query_params() :: list()
  defp allowed_query_params do
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
