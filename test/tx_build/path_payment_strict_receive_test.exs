defmodule Stellar.TxBuild.PathPaymentStrictReceiveTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [path_payment_strict_receive_op_xdr: 6]

  alias Stellar.TxBuild.{Account, Amount, Asset, AssetsPath, PathPaymentStrictReceive}

  setup do
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    asset_code4 = "BTCN"
    asset_code12 = "BTCNEW2000"

    destination = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    send_asset = :native
    send_max = 100
    dest_asset = {asset_code4, asset_issuer}
    dest_amount = 2_000
    path = [:native, {asset_code12, asset_issuer}]

    %{
      destination: destination,
      send_asset: send_asset,
      send_max: send_max,
      dest_asset: dest_asset,
      dest_amount: dest_amount,
      path: path,
      xdr:
        path_payment_strict_receive_op_xdr(
          destination,
          send_asset,
          send_max,
          dest_asset,
          dest_amount,
          path
        )
    }
  end

  test "new/2", %{
    destination: destination,
    send_asset: send_asset,
    send_max: send_max,
    dest_asset: dest_asset,
    dest_amount: dest_amount,
    path: path
  } do
    destination_str = Account.new(destination)
    asset_str = Asset.new(send_asset)
    amount_str = Amount.new(send_max)
    path_str = AssetsPath.new(path)

    %PathPaymentStrictReceive{
      destination: ^destination_str,
      send_asset: ^asset_str,
      send_max: ^amount_str,
      path: ^path_str
    } =
      PathPaymentStrictReceive.new(
        destination: destination,
        send_asset: send_asset,
        send_max: send_max,
        dest_asset: dest_asset,
        dest_amount: dest_amount,
        path: path
      )
  end

  test "new/2 with_invalid_destination" do
    {:error, [destination: :invalid_ed25519_public_key]} =
      PathPaymentStrictReceive.new(
        destination: "ABC",
        send_asset: :native,
        send_max: 100,
        dest_asset: :native,
        dest_amount: 50
      )
  end

  test "new/2 with_invalid_send_asset", %{destination: destination} do
    {:error, [send_asset: :invalid_asset_issuer]} =
      PathPaymentStrictReceive.new(
        destination: destination,
        send_asset: {"BTCN", "BAD"},
        send_max: 100,
        dest_asset: :native,
        dest_amount: 50
      )
  end

  test "new/2 with_invalid_amount", %{destination: destination} do
    {:error, [send_max: :invalid_amount]} =
      PathPaymentStrictReceive.new(
        destination: destination,
        send_asset: :native,
        send_max: "100",
        dest_asset: :native,
        dest_amount: 50
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = PathPaymentStrictReceive.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    destination: destination,
    send_asset: send_asset,
    send_max: send_max,
    dest_asset: dest_asset,
    dest_amount: dest_amount,
    path: path
  } do
    ^xdr =
      [
        destination: destination,
        send_asset: send_asset,
        send_max: send_max,
        dest_asset: dest_asset,
        dest_amount: dest_amount,
        path: path
      ]
      |> PathPaymentStrictReceive.new()
      |> PathPaymentStrictReceive.to_xdr()
  end
end
