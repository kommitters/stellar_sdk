defmodule Stellar.Horizon.Operation.ManageBuyOfferTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.ManageBuyOffer

  setup do
    %{
      attrs: %{
        amount: "1336.0326986",
        price: "0.0559999",
        price_r: %{
          n: 559_999,
          d: 10_000_000
        },
        selling_asset_type: "credit_alphanum4",
        selling_asset_code: "USD",
        selling_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
        buying_asset_type: "native",
        offer_id: "0"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        price_r: price_r,
        selling_asset_type: selling_asset_type,
        selling_asset_code: selling_asset_code,
        selling_asset_issuer: selling_asset_issuer,
        buying_asset_type: buying_asset_type,
        offer_id: offer_id
      } = attrs
  } do
    %ManageBuyOffer{
      amount: 1336.0326986,
      price: 0.0559999,
      price_r: ^price_r,
      selling_asset_type: ^selling_asset_type,
      selling_asset_code: ^selling_asset_code,
      selling_asset_issuer: ^selling_asset_issuer,
      buying_asset_type: ^buying_asset_type,
      offer_id: ^offer_id
    } = ManageBuyOffer.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ManageBuyOffer{
      amount: nil,
      price: nil,
      price_r: nil,
      selling_asset_type: nil,
      selling_asset_code: nil,
      selling_asset_issuer: nil,
      buying_asset_type: nil,
      offer_id: nil
    } = ManageBuyOffer.new(%{})
  end
end
