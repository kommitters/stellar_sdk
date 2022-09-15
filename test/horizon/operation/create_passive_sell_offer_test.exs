defmodule Stellar.Horizon.Operation.CreatePassiveSellOfferTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.CreatePassiveSellOffer

  setup do
    %{
      attrs: %{
        amount: "1.0000000",
        price: "1.0000000",
        price_r: %{
          n: 1,
          d: 1
        },
        buying_asset_type: "credit_alphanum4",
        buying_asset_code: "USD",
        buying_asset_issuer: "GBNLJIYH34UWO5YZFA3A3HD3N76R6DOI33N4JONUOHEEYZYCAYTEJ5AK",
        selling_asset_type: "credit_alphanum4",
        selling_asset_code: "USD",
        selling_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        amount: amount,
        price: price,
        price_r: price_r,
        buying_asset_type: buying_asset_type,
        buying_asset_code: buying_asset_code,
        buying_asset_issuer: buying_asset_issuer,
        selling_asset_type: selling_asset_type,
        selling_asset_code: selling_asset_code,
        selling_asset_issuer: selling_asset_issuer
      } = attrs
  } do
    %CreatePassiveSellOffer{
      amount: ^amount,
      price: ^price,
      price_r: ^price_r,
      buying_asset_type: ^buying_asset_type,
      buying_asset_code: ^buying_asset_code,
      buying_asset_issuer: ^buying_asset_issuer,
      selling_asset_type: ^selling_asset_type,
      selling_asset_code: ^selling_asset_code,
      selling_asset_issuer: ^selling_asset_issuer
    } = CreatePassiveSellOffer.new(attrs)
  end

  test "new/2 empty_attrs" do
    %CreatePassiveSellOffer{
      amount: nil,
      price: nil,
      price_r: nil,
      buying_asset_type: nil,
      buying_asset_code: nil,
      buying_asset_issuer: nil,
      selling_asset_type: nil,
      selling_asset_code: nil,
      selling_asset_issuer: nil
    } = CreatePassiveSellOffer.new(%{})
  end
end
