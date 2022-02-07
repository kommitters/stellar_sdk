defmodule Stellar.TxBuild.CreatePassiveSellOfferTest do
  use ExUnit.Case

  import Stellar.TxBuild.Utils, only: [number_to_fraction: 1]
  import Stellar.Test.XDRFixtures, only: [create_passive_sell_offer_op_xdr: 4]

  alias Stellar.TxBuild.{Amount, Asset, CreatePassiveSellOffer, Price}

  setup do
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    asset_code4 = "BTCN"

    selling = :native
    buying = {asset_code4, asset_issuer}
    amount = 100
    price = 2.15

    %{
      selling: selling,
      buying: buying,
      amount: amount,
      price: price,
      xdr:
        create_passive_sell_offer_op_xdr(
          selling,
          buying,
          amount,
          number_to_fraction(price)
        )
    }
  end

  test "new/2", %{
    selling: selling,
    buying: buying,
    amount: amount,
    price: price
  } do
    selling_str = Asset.new(selling)
    buying_str = Asset.new(buying)
    amount_str = Amount.new(amount)
    price_str = Price.new(price)

    %CreatePassiveSellOffer{
      selling: ^selling_str,
      buying: ^buying_str,
      amount: ^amount_str,
      price: ^price_str
    } =
      CreatePassiveSellOffer.new(
        selling: selling,
        buying: buying,
        amount: amount,
        price: price
      )
  end

  test "new/2 with_invalid_selling" do
    {:error, [selling: :invalid_asset]} =
      CreatePassiveSellOffer.new(
        selling: :test,
        buying: :native,
        amount: 100,
        price: 2.15
      )
  end

  test "new/2 with_invalid_amount", %{selling: selling, buying: buying} do
    {:error, [amount: :invalid_amount]} =
      CreatePassiveSellOffer.new(
        selling: selling,
        buying: buying,
        amount: "100",
        price: 2.15
      )
  end

  test "new/2 with_invalid_price", %{selling: selling, buying: buying} do
    {:error, [price: :invalid_price]} =
      CreatePassiveSellOffer.new(
        selling: selling,
        buying: buying,
        amount: 100,
        price: "ABC"
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = CreatePassiveSellOffer.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    selling: selling,
    buying: buying,
    amount: amount,
    price: price
  } do
    ^xdr =
      [
        selling: selling,
        buying: buying,
        amount: amount,
        price: price
      ]
      |> CreatePassiveSellOffer.new()
      |> CreatePassiveSellOffer.to_xdr()
  end
end
