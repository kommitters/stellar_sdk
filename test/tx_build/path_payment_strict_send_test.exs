defmodule Stellar.TxBuild.PathPaymentStrictSendTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [path_payment_strict_send_op_xdr: 6]

  alias Stellar.TxBuild.{Account, Amount, Asset, AssetsPath, PathPaymentStrictSend}

  setup do
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    asset_code4 = "BTCN"
    asset_code12 = "BTCNEW2000"

    destination = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    send_asset = :native
    send_amount = 100
    dest_asset = {asset_code4, asset_issuer}
    dest_min = 2_000
    path = [:native, {asset_code12, asset_issuer}]

    %{
      destination: destination,
      send_asset: send_asset,
      send_amount: send_amount,
      dest_asset: dest_asset,
      dest_min: dest_min,
      path: path,
      xdr:
        path_payment_strict_send_op_xdr(
          destination,
          send_asset,
          send_amount,
          dest_asset,
          dest_min,
          path
        )
    }
  end

  test "new/2", %{
    destination: destination,
    send_asset: send_asset,
    send_amount: send_amount,
    dest_asset: dest_asset,
    dest_min: dest_min,
    path: path
  } do
    destination_str = Account.new(destination)
    asset_str = Asset.new(send_asset)
    amount_str = Amount.new(send_amount)
    path_str = AssetsPath.new(path)

    %PathPaymentStrictSend{
      destination: ^destination_str,
      send_asset: ^asset_str,
      send_amount: ^amount_str,
      path: ^path_str
    } =
      PathPaymentStrictSend.new(
        destination: destination,
        send_asset: send_asset,
        send_amount: send_amount,
        dest_asset: dest_asset,
        dest_min: dest_min,
        path: path
      )
  end

  test "new/2 with_invalid_destination" do
    {:error, [destination: :invalid_ed25519_public_key]} =
      PathPaymentStrictSend.new(
        destination: "ABC",
        send_asset: :native,
        send_amount: 100,
        dest_asset: :native,
        dest_min: 50
      )
  end

  test "new/2 with_invalid_send_asset", %{destination: destination} do
    {:error, [send_asset: :invalid_asset_issuer]} =
      PathPaymentStrictSend.new(
        destination: destination,
        send_asset: {"BTCN", "BAD"},
        send_amount: 100,
        dest_asset: :native,
        dest_min: 50
      )
  end

  test "new/2 with_invalid_amount", %{destination: destination} do
    {:error, [send_amount: :invalid_amount]} =
      PathPaymentStrictSend.new(
        destination: destination,
        send_asset: :native,
        send_amount: "100",
        dest_asset: :native,
        dest_min: 50
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = PathPaymentStrictSend.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    destination: destination,
    send_asset: send_asset,
    send_amount: send_amount,
    dest_asset: dest_asset,
    dest_min: dest_min,
    path: path
  } do
    ^xdr =
      [
        destination: destination,
        send_asset: send_asset,
        send_amount: send_amount,
        dest_asset: dest_asset,
        dest_min: dest_min,
        path: path
      ]
      |> PathPaymentStrictSend.new()
      |> PathPaymentStrictSend.to_xdr()
  end
end
