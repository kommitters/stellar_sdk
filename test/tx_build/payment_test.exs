defmodule Stellar.TxBuild.PaymentTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [payment_op_xdr: 3]

  alias Stellar.TxBuild.{Account, Amount, Asset, Payment}

  setup do
    destination = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    asset_code = "BTCN"
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    amount = 100

    %{
      destination: destination,
      asset: {asset_code, asset_issuer},
      amount: amount,
      xdr: payment_op_xdr(destination, {asset_code, asset_issuer}, amount)
    }
  end

  test "new/2", %{destination: destination, asset: asset, amount: amount} do
    destination_str = Account.new(destination)
    asset_str = Asset.new(asset)
    amount_str = Amount.new(amount)

    %Payment{destination: ^destination_str, asset: ^asset_str, amount: ^amount_str} =
      Payment.new(
        destination: destination,
        asset: asset,
        amount: amount
      )
  end

  test "new/2 with_invalid_destination" do
    {:error, [destination: :invalid_ed25519_public_key]} =
      Payment.new(
        destination: "ABC",
        asset: :native,
        amount: 10
      )
  end

  test "new/2 with_invalid_asset", %{destination: destination} do
    {:error, [asset: :invalid_asset_issuer]} =
      Payment.new(
        destination: destination,
        asset: {"BTCN", "ABC"},
        amount: 10
      )
  end

  test "new/2 with_invalid_amount", %{destination: destination} do
    {:error, [amount: :invalid_amount]} =
      Payment.new(
        destination: destination,
        asset: :native,
        amount: "10"
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = Payment.new("ABC", "123")
  end

  test "to_xdr/1", %{xdr: xdr, destination: destination, asset: asset, amount: amount} do
    ^xdr =
      [destination: destination, asset: asset, amount: amount]
      |> Payment.new()
      |> Payment.to_xdr()
  end
end
