defmodule Stellar.Horizon.OrderBookTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.OrderBook
  alias Stellar.Horizon.OrderBook.Price

  setup do
    json_body = Horizon.fixture("order_book")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
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
    } = OrderBook.new(attrs)
  end
end
