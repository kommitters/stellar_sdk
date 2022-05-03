defmodule Stellar.TxBuild.Ledger.OfferTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{AccountID, Ledger.Offer}

  setup do
    seller_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    offer_id = 123

    %{
      seller_id: seller_id,
      offer_id: offer_id,
      xdr: XDRFixtures.ledger_offer(seller_id, offer_id)
    }
  end

  test "new/2", %{seller_id: seller_id, offer_id: offer_id} do
    %Offer{seller: %AccountID{account_id: ^seller_id}, offer_id: ^offer_id} =
      Offer.new(seller: seller_id, offer_id: offer_id)
  end

  test "new/2 invalid_seller", %{offer_id: offer_id} do
    {:error, :invalid_seller} = Offer.new(seller: "ABCD", offer_id: offer_id)
  end

  test "new/2 invalid_offer_id", %{seller_id: seller_id} do
    {:error, :invalid_offer_id} = Offer.new(seller: seller_id, offer_id: "ABCD")
  end

  test "new/2 offer_id_exceeds_value", %{seller_id: seller_id} do
    {:error, :invalid_offer_id} =
      Offer.new(seller: seller_id, offer_id: 9_223_372_036_854_775_808)
  end

  test "to_xdr/1", %{xdr: xdr, seller_id: seller_id, offer_id: offer_id} do
    ^xdr =
      [seller: seller_id, offer_id: offer_id]
      |> Offer.new()
      |> Offer.to_xdr()
  end
end
