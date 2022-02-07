defmodule Stellar.TxBuild.ManageSellOfferTest do
  use ExUnit.Case

  import Stellar.TxBuild.Utils, only: [number_to_fraction: 1]
  import Stellar.Test.XDRFixtures, only: [manage_sell_offer_op_xdr: 5]

  alias Stellar.TxBuild.{Amount, Asset, ManageSellOffer, Price}

  setup do
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    asset_code4 = "BTCN"

    selling = :native
    buying = {asset_code4, asset_issuer}
    amount = 100
    price = 2.15
    offer_id = 0

    %{
      selling: selling,
      buying: buying,
      amount: amount,
      price: price,
      offer_id: offer_id,
      xdr:
        manage_sell_offer_op_xdr(
          selling,
          buying,
          amount,
          number_to_fraction(price),
          offer_id
        )
    }
  end

  test "new/2", %{
    selling: selling,
    buying: buying,
    amount: amount,
    price: price,
    offer_id: offer_id
  } do
    selling_str = Asset.new(selling)
    buying_str = Asset.new(buying)
    amount_str = Amount.new(amount)
    price_str = Price.new(price)

    %ManageSellOffer{
      selling: ^selling_str,
      buying: ^buying_str,
      amount: ^amount_str,
      price: ^price_str
    } =
      ManageSellOffer.new(
        selling: selling,
        buying: buying,
        amount: amount,
        price: price,
        offer_id: offer_id
      )
  end

  test "new/2 with_invalid_selling" do
    {:error, [selling: :invalid_asset]} =
      ManageSellOffer.new(
        selling: :test,
        buying: :native,
        amount: 100,
        price: 2.15,
        offer_id: 0
      )
  end

  test "new/2 with_invalid_amount", %{selling: selling, buying: buying} do
    {:error, [amount: :invalid_amount]} =
      ManageSellOffer.new(
        selling: selling,
        buying: buying,
        amount: "100",
        price: 2.15,
        offer_id: 0
      )
  end

  test "new/2 with_invalid_price", %{selling: selling, buying: buying} do
    {:error, [price: :invalid_price]} =
      ManageSellOffer.new(
        selling: selling,
        buying: buying,
        amount: 100,
        price: "ABC",
        offer_id: 0
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = ManageSellOffer.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    selling: selling,
    buying: buying,
    amount: amount,
    price: price,
    offer_id: offer_id
  } do
    ^xdr =
      [
        selling: selling,
        buying: buying,
        amount: amount,
        price: price,
        offer_id: offer_id
      ]
      |> ManageSellOffer.new()
      |> ManageSellOffer.to_xdr()
  end
end
