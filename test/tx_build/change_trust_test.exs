defmodule Stellar.TxBuild.ChangeTrustTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [change_trust_xdr: 2]

  alias Stellar.TxBuild.{Amount, Asset, ChangeTrust}

  setup do
    asset_code = "BTCN"
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    amount = 100

    %{
      asset: {asset_code, asset_issuer},
      amount: amount,
      xdr: change_trust_xdr({asset_code, asset_issuer}, amount)
    }
  end

  test "new/2", %{asset: asset, amount: amount} do
    asset_str = Asset.new(asset)
    amount_str = Amount.new(amount)

    %ChangeTrust{asset: ^asset_str, amount: ^amount_str} =
      ChangeTrust.new(asset: asset, amount: amount)
  end

  test "new/2 with_default_amount", %{asset: asset} do
    asset_str = Asset.new(asset)
    amount_str = Amount.new(:max)

    %ChangeTrust{asset: ^asset_str, amount: ^amount_str} = ChangeTrust.new(asset: asset)
  end

  test "new/2 with_invalid_asset" do
    {:error, [asset: :invalid_asset_issuer]} = ChangeTrust.new(asset: {"BTCN", "ABC"}, amount: 10)
  end

  test "new/2 with_invalid_amount" do
    {:error, [amount: :invalid_amount]} = ChangeTrust.new(asset: :native, amount: "10")
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = ChangeTrust.new("ABC", "123")
  end

  test "to_xdr/1", %{xdr: xdr, asset: asset, amount: amount} do
    ^xdr =
      [asset: asset, amount: amount]
      |> ChangeTrust.new()
      |> ChangeTrust.to_xdr()
  end
end
