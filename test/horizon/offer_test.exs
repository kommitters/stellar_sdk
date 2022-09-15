defmodule Stellar.Horizon.OfferTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Offer

  setup do
    json_body = Horizon.fixture("offer")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Offer{
      id: 165_561_423,
      seller: "GCK4WSNF3F6ZNCMK6BU77ZCZ3NMF3JGU2U3ZAPKXYBKYYCJA72FDBY7K",
      selling: %{
        asset_type: "credit_alphanum4",
        asset_code: "NGNT",
        asset_issuer: "GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD"
      },
      buying: %{
        asset_type: "native"
      },
      amount: "18421.4486092",
      price_r: %{
        n: 45_112_058,
        d: 941_460_545
      },
      price: "0.0479171",
      last_modified_ledger: 28_411_995,
      last_modified_time: ~U[2020-02-26 19:29:16Z]
    } = Offer.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Offer{
      id: nil,
      seller: nil,
      selling: nil,
      buying: nil,
      amount: nil,
      price_r: nil,
      price: nil,
      last_modified_ledger: nil,
      last_modified_time: nil
    } = Offer.new(%{})
  end
end
