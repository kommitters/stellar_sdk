defmodule Stellar.Horizon.Operation.ManageSellOfferTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.ManageSellOffer

  setup do
    %{
      attrs: %{
        amount: "1336.0326986",
        price: "0.0559999",
        price_r: %{
          n: 559_999,
          d: 10_000_000
        },
        buying_asset_type: "credit_alphanum4",
        buying_asset_code: "USD",
        buying_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
        selling_asset_type: "native",
        offer_id: "0"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        price_r: price_r,
        buying_asset_type: buying_asset_type,
        buying_asset_code: buying_asset_code,
        buying_asset_issuer: buying_asset_issuer,
        selling_asset_type: selling_asset_type,
        offer_id: offer_id
      } = attrs
  } do
    %ManageSellOffer{
      amount: 1336.0326986,
      price: 0.0559999,
      price_r: ^price_r,
      buying_asset_type: ^buying_asset_type,
      buying_asset_code: ^buying_asset_code,
      buying_asset_issuer: ^buying_asset_issuer,
      selling_asset_type: ^selling_asset_type,
      offer_id: ^offer_id
    } = ManageSellOffer.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ManageSellOffer{
      amount: nil,
      price: nil,
      price_r: nil,
      buying_asset_type: nil,
      buying_asset_code: nil,
      buying_asset_issuer: nil,
      selling_asset_type: nil,
      offer_id: nil
    } = ManageSellOffer.new(%{})
  end
end
