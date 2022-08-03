defmodule Stellar.Horizon.Client.CannedTradeRequests do
  @moduledoc false

  alias Stellar.Test.Fixtures.Horizon

  @base_url "https://horizon-testnet.stellar.org"

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          options :: list()
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, atom()}
  def request(:get, @base_url <> "/trades?cursor=error", _headers, _body, _opts) do
    json_error = Horizon.fixture("400")
    {:ok, 400, [], json_error}
  end

  def request(
        :get,
        @base_url <> "/trades?cursor=107449584845914113-0" <> _query,
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
        @base_url <> "/trades?cursor=107449468881756161-0" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/trades" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("trades")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.TradesTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedTradeRequests
  alias Stellar.Horizon.{Collection, Error, Trade, Trades}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedTradeRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Trade{
           base_account: "GCO7OW5P2PP7WDN6YUDXUUOPAR4ZHJSDDCZTIAQRTRZHKQWV45WUPBWX",
           base_amount: 4433.2,
           base_asset_code: nil,
           base_asset_issuer: nil,
           base_asset_type: "native",
           base_is_seller: true,
           base_liquidity_pool_id: nil,
           base_offer_id: 165_561_423,
           counter_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
           counter_amount: 443.32,
           counter_asset_code: "BB1",
           counter_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           counter_asset_type: "credit_alphanum4",
           counter_liquidity_pool_id: nil,
           counter_offer_id: "4719135487309144065",
           id: "107449468881756161-0",
           ledger_close_time: ~U[2019-07-26 09:17:02Z],
           paging_token: "107449468881756161-0",
           price: %{d: "10", n: "1"},
           trade_type: nil
         },
         %Trade{
           base_account: "GCQDOTIILRG634IRWAODTUS6H6Q7VUUNKZINBDJOXGJFR7YZ57FGYV7B",
           base_amount: 10.0,
           base_asset_code: nil,
           base_asset_issuer: nil,
           base_asset_type: "native",
           base_is_seller: true,
           base_liquidity_pool_id: nil,
           base_offer_id: 165_561_423,
           counter_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
           counter_amount: 1.0,
           counter_asset_code: "BB1",
           counter_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           counter_asset_type: "credit_alphanum4",
           counter_liquidity_pool_id: nil,
           counter_offer_id: "4719135504489037825",
           id: "107449486061649921-0",
           ledger_close_time: ~U[2019-07-26 09:17:25Z],
           paging_token: "107449486061649921-0",
           price: %{d: "10", n: "1"},
           trade_type: nil
         },
         %Trade{
           base_account: "GAMU5TQFUMDGVKYQPPDCD2MKKUUWELSQAEKNNU4RFQCWFSRBPJA2MAGQ",
           base_amount: 748.5338945,
           base_asset_code: nil,
           base_asset_issuer: nil,
           base_asset_type: "native",
           base_is_seller: true,
           base_liquidity_pool_id: nil,
           base_offer_id: 165_561_423,
           counter_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
           counter_amount: 74.8533887,
           counter_asset_code: "BB1",
           counter_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           counter_asset_type: "credit_alphanum4",
           counter_liquidity_pool_id: nil,
           counter_offer_id: "104299548",
           id: "107449584845914113-0",
           ledger_close_time: ~U[2019-07-26 09:19:30Z],
           paging_token: "107449584845914113-0",
           price: %{d: "100000001", n: "10000000"},
           trade_type: nil
         }
       ]
     }} = Trades.all(limit: 3)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Trades.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Trades.all(limit: 3)
    paginate_next_fn.()

    assert_receive({:paginated, :next})
  end

  test "error" do
    {:error,
     %Error{
       detail: "The request you sent was invalid in some way.",
       extras: %{invalid_field: "cursor", reason: "cursor: invalid value"},
       status_code: 400,
       title: "Bad Request",
       type: "https://stellar.org/horizon-errors/bad_request"
     }} = Trades.all(cursor: "error")
  end
end
