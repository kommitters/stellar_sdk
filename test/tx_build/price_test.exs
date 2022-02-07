defmodule Stellar.TxBuild.PriceTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Price
  alias StellarBase.XDR.Int32
  alias StellarBase.XDR.Price, as: PriceXDR

  test "new/2" do
    %Price{price: 2.15, numerator: 43, denominator: 20} = Price.new(2.15)
  end

  test "new/2 with_integer_values" do
    %Price{price: 2, numerator: 2, denominator: 1} = Price.new(2)
  end

  test "new/2 invalid" do
    {:error, :invalid_price} = Price.new("123")
  end

  test "to_xdr/1" do
    numerator = Int32.new(43)
    denominator = Int32.new(20)
    price_xdr = PriceXDR.new(numerator, denominator)

    ^price_xdr =
      2.15
      |> Price.new()
      |> Price.to_xdr()
  end
end
