defmodule Stellar.TxBuild.AssetTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures,
    only: [create_asset4_xdr: 2, create_asset12_xdr: 2, create_asset_native_xdr: 0]

  alias Stellar.TxBuild.Asset

  setup do
    code4 = "BTCN"
    code12 = "BTCNEW20000"
    issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"

    %{
      code4: code4,
      code12: code12,
      issuer: issuer,
      asset_native_xdr: create_asset_native_xdr(),
      asset_code4_xdr: create_asset4_xdr(code4, issuer),
      asset_code12_xdr: create_asset12_xdr(code12, issuer)
    }
  end

  test "new/2" do
    %Asset{code: "XLM", type: :native} = Asset.new(:native)
  end

  test "new/2 with_tuple_arguments", %{code4: code4, issuer: issuer} do
    %Asset{code: ^code4, type: :alpha_num4} = Asset.new({code4, issuer})
  end

  test "new/2 with_list_arguments", %{code12: code12, issuer: issuer} do
    %Asset{code: ^code12, type: :alpha_num12} = Asset.new(code: code12, issuer: issuer)
  end

  test "new/2 with_invalid_arguments", %{code4: code4, issuer: issuer} do
    {:error, :invalid_asset} = Asset.new(code4, issuer)
  end

  test "to_xdr/1", %{asset_native_xdr: xdr} do
    ^xdr =
      :native
      |> Asset.new()
      |> Asset.to_xdr()
  end

  test "to_xdr/1 alpha_num4", %{asset_code4_xdr: xdr, code4: code4, issuer: issuer} do
    ^xdr =
      [code: code4, issuer: issuer]
      |> Asset.new()
      |> Asset.to_xdr()
  end

  test "to_xdr/1 alpha_num12", %{asset_code12_xdr: xdr, code12: code12, issuer: issuer} do
    ^xdr =
      [code: code12, issuer: issuer]
      |> Asset.new()
      |> Asset.to_xdr()
  end
end
