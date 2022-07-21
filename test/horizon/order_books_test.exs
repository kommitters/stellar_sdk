defmodule Stellar.Horizon.Client.CannedOrderBooksRequests do
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
          "/order_book?selling_asset_type=native&buying_asset_type=credit_alphanum4&buying_asset_code=USD&buying_asset_issuer=GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX&limit=2",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("order_book")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/order_book?buying_asset_type=error", _headers, _body, _opts) do
    json_error = Horizon.fixture("400_invalid_order_book")
    {:ok, 400, [], json_error}
  end
end

defmodule Stellar.Horizon.OrderBooksTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedOrderBooksRequests
  alias Stellar.Horizon.{OrderBooks, OrderBook, Error}
  alias Stellar.Horizon.OrderBook.Price

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedOrderBooksRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      selling_asset_type: :native,
      buying_asset_type: :credit_alphanum4,
      buying_asset_code: "USD",
      buying_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
      limit: 2
    }
  end

  test "retrieve/1", %{
    selling_asset_type: selling_asset_type,
    buying_asset_type: buying_asset_type,
    buying_asset_code: buying_asset_code,
    buying_asset_issuer: buying_asset_issuer,
    limit: limit
  } do
    {:ok,
     %OrderBook{
       asks: [
         %Price{
           amount: 8057.2710223,
           price: 0.0590815,
           price_r: %{d: 2_000_000, n: 118_163}
         },
         %Price{
           amount: 1.0e4,
           price: 0.060627,
           price_r: %{d: 1_000_000, n: 60_627}
         }
       ],
       base: %{asset_type: "native"},
       bids: [
         %Price{
           amount: 0.1722469,
           price: 0.058808,
           price_r: %{d: 102_275_119, n: 6_014_600}
         },
         %Price{
           amount: 0.2991796,
           price: 0.0572577,
           price_r: %{d: 21_831_117, n: 1_250_000}
         }
       ],
       counter: %{
         asset_code: "USD",
         asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
         asset_type: "credit_alphanum4"
       }
     }} =
      OrderBooks.retrieve(
        selling_asset_type: selling_asset_type,
        buying_asset_type: buying_asset_type,
        buying_asset_code: buying_asset_code,
        buying_asset_issuer: buying_asset_issuer,
        limit: limit
      )
  end

  test "error" do
    {:error,
     %Error{
       status_code: 400,
       title: "Invalid Order Book Parameters",
       type: "https://stellar.org/horizon-errors/invalid_order_book"
     }} = OrderBooks.retrieve(buying_asset_type: :error)
  end
end
