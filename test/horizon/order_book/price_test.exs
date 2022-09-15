defmodule Stellar.Horizon.OrderBook.PriceTest do
  use ExUnit.Case

  alias Stellar.Horizon.OrderBook.Price

  setup do
    %{
      attrs: %{
        price_r: %{n: 6_014_600, d: 102_275_119},
        price: "0.0588080",
        amount: "0.1722469"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        price_r: price_r,
        price: price,
        amount: amount
      } = attrs
  } do
    %Price{
      price_r: ^price_r,
      price: ^price,
      amount: ^amount
    } = Price.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Price{price_r: nil, price: nil, amount: nil} = Price.new(%{})
  end
end
