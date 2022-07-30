defmodule Stellar.Horizon.TradeAggregations do
  @moduledoc """
  Exposes functions to interact with Trade Aggregations in Horizon.

  You can:
  * List trade aggreation data based on filters set in the arguments

  Horizon API reference: https://developers.stellar.org/api/aggregations/trade-aggregations/
  """

  alias Stellar.Horizon.{Error, Request, RequestParams, TradeAggregation}

  @type args :: Keyword.t()
  @type resource :: TradeAggregation.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "trade_aggregations"

  @doc """
    List trade aggreation data based on filters set in the arguments.

    ## Parameters

      * `base_asset`: :native or [code: `selling_asset_code`, issuer: `selling_asset_issuer`]
      * `counter_asset`: :native or [code: `selling_asset_code`, issuer: `selling_asset_issuer`]
      * `resolution`: The segment duration represented as milliseconds.

    ## Options

      * `start_time`: The lower time boundary represented as milliseconds since epoch.
      * `end_time`: The upper time boundary represented as milliseconds since epoch.
      * `offset`: Segments can be offset using this parameter. Expressed in milliseconds.
      * `order`: A designation of the order in which records should appear.
      * `limit`: The maximum number of records returned.

    ## Examples

      iex> TradeAggregations.list_trade_aggreations(base_asset: :native, counter_asset: :native, resolution: "60000")
      {:ok, %Collection{records: [%TradeAggregation{}, ...]}}

      iex> TradeAggregations.list_trade_aggreations(base_asset: :native,
                                                    counter_asset: [
                                                      code: "EURT",
                                                      issuer: "GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S"
                                                    ],
                                                    resolution: "3600000",
                                                    start_time: "1582156800000",
                                                    end_time: "1582178400000"
                                                    )
      {:ok, %Collection{records: [%TradeAggregation{}, ...]}}
  """

  @spec list_trade_aggreations(args :: args()) :: response()
  def list_trade_aggreations(args \\ []) do
    params = resolve_params(args)

    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: allowed_query_options())
    |> Request.perform()
    |> Request.results(collection: {TradeAggregation, &list_trade_aggreations/1})
  end

  @spec resolve_params(args :: args()) :: Keyword.t()
  defp resolve_params(args) do
    base_asset = RequestParams.build_assets_params(args, :base_asset)
    counter_asset = RequestParams.build_assets_params(args, :counter_asset)

    if Enum.empty?(base_asset) && Enum.empty?(counter_asset) do
      args
    else
      args
      |> Keyword.take([:resolution, :start_time, :end_time, :offset, :order, :limit])
      |> Keyword.merge(base_asset)
      |> Keyword.merge(counter_asset)
    end
  end

  @spec allowed_query_options() :: list()
  defp allowed_query_options do
    [
      :base_asset_type,
      :base_asset_issuer,
      :base_asset_code,
      :counter_asset_type,
      :counter_asset_issuer,
      :counter_asset_code,
      :resolution,
      :start_time,
      :end_time,
      :offset
    ]
  end
end
