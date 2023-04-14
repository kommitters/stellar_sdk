defmodule Stellar.TxBuild.FromAssetTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [from_asset_xdr: 2]

  alias Stellar.TxBuild.FromAsset, as: TxFromAsset
  alias Stellar.TxBuild.Asset, as: TxAsset

  setup do
    asset = TxAsset.new(:native)
    network_id = "network_id"
    xdr = from_asset_xdr(network_id, asset)

    %{
      network_id: "network_id",
      asset: asset,
      xdr: xdr
    }
  end

  test "new/1", %{network_id: network_id, asset: asset} do
    %TxFromAsset{
      network_id: ^network_id,
      asset: ^asset
    } = TxFromAsset.new(network_id: network_id, asset: :native)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_from_asset} = TxFromAsset.new("invalid_args")
  end

  test "to_xdr/1", %{
    network_id: network_id,
    xdr: xdr
  } do
    ^xdr =
      TxFromAsset.new(network_id: network_id, asset: :native)
      |> TxFromAsset.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_from_asset} = TxFromAsset.to_xdr("invalid_struct")
  end
end
