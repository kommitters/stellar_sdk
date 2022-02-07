defmodule Stellar.TxBuild.AssetsPathTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures,
    only: [assets_path_xdr: 1]

  alias Stellar.TxBuild.{Asset, AssetsPath}

  setup do
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    asset_code4 = "BTCN"
    asset_code12 = "BTCNEW2000"
    raw_assets = [:native, {asset_code4, asset_issuer}, {asset_code12, asset_issuer}]

    %{
      raw_assets: raw_assets,
      assets: Enum.map(raw_assets, &Asset.new/1),
      assets_path_xdr: assets_path_xdr(raw_assets)
    }
  end

  test "new/2", %{raw_assets: raw_assets, assets: assets} do
    %AssetsPath{assets: ^assets} = AssetsPath.new(raw_assets)
  end

  test "new/2 empty_path" do
    %AssetsPath{assets: []} = AssetsPath.new()
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_asset_issuer} = AssetsPath.new([:native, {"TEST", "issuer"}])
  end

  test "to_xdr/1", %{assets_path_xdr: xdr, raw_assets: raw_assets} do
    ^xdr =
      raw_assets
      |> AssetsPath.new()
      |> AssetsPath.to_xdr()
  end
end
