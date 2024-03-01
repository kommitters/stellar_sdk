defmodule Stellar.Horizon.Client.CannedTradeAggregationRequests do
  @moduledoc false

  alias Stellar.Test.Fixtures.Horizon

  @base_url "https://horizon-testnet.stellar.org"

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          options :: list()
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, atom}

  def request(
        :get,
        @base_url <>
          "/trade_aggregations?resolution=3600000&start_time=1582156800000&end_time=1582178400000&limit=2&base_asset_type=native&counter_asset_type=credit_alphanum4&counter_asset_code=EURT&counter_asset_issuer=GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("trade_aggregations")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/trade_aggregations?base_asset_type=native&counter_asset_code=NGNT&counter_asset_issuer=GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD&counter_asset_type=credit_alphanum4&end_time=1582178400000&limit=200&order=asc&resolution=3600000&start_time=1582178400000" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :next})
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/trade_aggregations?base_asset_type=native&counter_asset_code=NGNT&counter_asset_issuer=GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD&counter_asset_type=credit_alphanum4&limit=200&order=asc&resolution=3600000&start_time=1582156800000&end_time=1582178400000" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/trade_aggregations", _headers, _body, _opts) do
    json_error = Horizon.fixture("400_invalid_trade_aggregations")
    {:ok, 400, [], json_error}
  end
end

defmodule Stellar.Horizon.TradeAggregationsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedTradeAggregationRequests
  alias Stellar.Horizon.{Collection, TradeAggregation, TradeAggregations, Error, Server}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedTradeAggregationRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      base_asset: :native,
      counter_asset: [
        code: "EURT",
        issuer: "GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S"
      ],
      resolution: "3600000",
      start_time: "1582156800000",
      end_time: "1582178400000",
      limit: 2
    }
  end

  test "list_trade_aggregations/1", %{
    base_asset: base_asset,
    counter_asset: counter_asset,
    resolution: resolution,
    start_time: start_time,
    end_time: end_time,
    limit: limit
  } do
    {:ok,
     %Collection{
       records: [
         %TradeAggregation{
           avg: "25.4268566",
           base_volume: "3487.4699458",
           close: "25.7090558",
           close_r: %{d: 48_621, n: 1_250_000},
           counter_volume: "88675.3982178",
           high: "25.7603393",
           high_r: %{d: 10_000_000, n: 257_603_393},
           low: "25.3804530",
           low_r: %{d: 1_000_000, n: 25_380_453},
           open: "25.3990186",
           open_r: %{d: 98_429, n: 2_500_000},
           timestamp: 1_582_156_800_000,
           trade_count: 9
         },
         %TradeAggregation{
           avg: "25.6476024",
           base_volume: "0.1058787",
           close: "25.6476019",
           close_r: %{d: 3899, n: 100_000},
           counter_volume: "2.7155348",
           high: "25.6476019",
           high_r: %{d: 3899, n: 100_000},
           low: "25.6476019",
           low_r: %{d: 3899, n: 100_000},
           open: "25.6476019",
           open_r: %{d: 3899, n: 100_000},
           timestamp: 1_582_160_400_000,
           trade_count: 1
         }
       ]
     }} =
      TradeAggregations.list_trade_aggregations(
        Server.testnet(),
        base_asset: base_asset,
        counter_asset: counter_asset,
        resolution: resolution,
        start_time: start_time,
        end_time: end_time,
        limit: limit
      )
  end

  test "paginate_collection prev", %{
    base_asset: base_asset,
    counter_asset: counter_asset,
    resolution: resolution,
    start_time: start_time,
    end_time: end_time,
    limit: limit
  } do
    {:ok, %Collection{prev: paginate_prev_fn}} =
      TradeAggregations.list_trade_aggregations(
        Server.testnet(),
        base_asset: base_asset,
        counter_asset: counter_asset,
        resolution: resolution,
        start_time: start_time,
        end_time: end_time,
        limit: limit
      )

    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next", %{
    base_asset: base_asset,
    counter_asset: counter_asset,
    resolution: resolution,
    start_time: start_time,
    end_time: end_time,
    limit: limit
  } do
    {:ok, %Collection{next: paginate_next_fn}} =
      TradeAggregations.list_trade_aggregations(
        Server.testnet(),
        base_asset: base_asset,
        counter_asset: counter_asset,
        resolution: resolution,
        start_time: start_time,
        end_time: end_time,
        limit: limit
      )

    paginate_next_fn.()

    assert_receive({:paginated, :next})
  end

  test "error" do
    {:error,
     %Error{
       detail: "The request you sent was invalid in some way.",
       extras: %{invalid_field: "counter_asset_type", reason: "Missing required field"},
       status_code: 400,
       title: "Bad Request",
       type: "https://stellar.org/horizon-errors/bad_request"
     }} = TradeAggregations.list_trade_aggregations(Server.testnet(), base_asset: :error)
  end
end
