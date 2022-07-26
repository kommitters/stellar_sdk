defmodule Stellar.Horizon.OrderBooks do
  @moduledoc """
  Exposes functions to interact with OrderBooks in Horizon.

  You can:
  * Retrieve an order book’s bids and asks

  Horizon API reference: https://developers.stellar.org/api/aggregations/order-books/object/
  """

  alias Stellar.Horizon.{Error, OrderBook, Request, RequestParams}

  @type args :: Keyword.t()
  @type resource :: OrderBook.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "order_book"

  @doc """
    Retrieve order books

  ## Parameters
    * `selling_asset_type`: The type for the asset being sold (base asset), native, credit_alphanum4, or credit_alphanum12
    * `buying_asset_type`: The type for the asset being bought (counter asset), native, credit_alphanum4, or credit_alphanum12

  ## Options
    * `selling_asset_issuer`: The Stellar address of the issuer of the asset being sold (base asset). Required if the selling_asset_type is not native
    * `selling_asset_code`: The code for the asset being sold (base asset). Required if the selling_asset_type is not native.
    * `buying_asset_issuer`: The Stellar address of the issuer of the asset being bought (counter asset). Required if the buying_asset_type is not native.
    * `buying_asset_code`: The code for the asset being bought (counter asset). Required if the buying_asset_type is not native.
    * `limit`: The maximum number of records returned

  ## Examples

    # Retrieve order books
    iex> OrderBooks.retrieve(selling_asset: :native, buying_asset: :native)

    {:ok, %OrderBook{bids: [%Price{}...], asks: [%Price{}...], ...}

    # Retrieve with more options
    iex> OrderBooks.retrieve(selling_asset: :native,
                             buying_asset: [
                                code: "BB1",
                                issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
                              ],
                             limit: 2
                            )
    {:ok, %OrderBook{bids: [%Price{}...], asks: [%Price{}...], ...}
  """

  @spec retrieve(args :: args()) :: response()
  def retrieve(args \\ []) do
    selling_asset = RequestParams.build_assets_params(args, :selling_asset)
    buying_asset = RequestParams.build_assets_params(args, :buying_asset)

    params =
      args
      |> Keyword.take([:limit])
      |> Keyword.merge(selling_asset)
      |> Keyword.merge(buying_asset)

    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: allowed_query_options())
    |> Request.perform()
    |> Request.results(as: OrderBook)
  end

  @spec allowed_query_options() :: list()
  defp allowed_query_options do
    [
      :selling_asset_type,
      :buying_asset_type,
      :selling_asset_issuer,
      :selling_asset_code,
      :buying_asset_issuer,
      :buying_asset_code
    ]
  end
end
