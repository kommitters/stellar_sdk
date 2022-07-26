defmodule Stellar.Horizon.RequestParamsTest do
  use ExUnit.Case

  alias Stellar.Horizon.RequestParams

  setup do
    %{
      selling_asset: :native,
      buying_asset: [
        code: "BB1",
        issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
      ]
    }
  end

  test "build_assets_params/2 empty params" do
    [] = RequestParams.build_assets_params([], :selling_asset)
  end

  test "build_assets_params/2 unauthorized type" do
    [] = RequestParams.build_assets_params([selling_asset: :error], :test)
  end

  test "build_assets_params/2", %{
    selling_asset: selling_asset,
    buying_asset: buying_asset
  } do
    args = [selling_asset: selling_asset, buying_asset: buying_asset]
    [selling_asset_type: :native] = RequestParams.build_assets_params(args, :selling_asset)

    [
      buying_asset_type: :credit_alphanum4,
      buying_asset_code: "BB1",
      buying_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
    ] = RequestParams.build_assets_params(args, :buying_asset)
  end

  test "build_assets_params/2 with other asset code", %{
    selling_asset: selling_asset,
    buying_asset: buying_asset
  } do
    args = [
      selling_asset: selling_asset,
      buying_asset: Keyword.put(buying_asset, :code, "000000AWD")
    ]

    [selling_asset_type: :native] = RequestParams.build_assets_params(args, :selling_asset)

    [
      buying_asset_type: :credit_alphanum12,
      buying_asset_code: "000000AWD",
      buying_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
    ] = RequestParams.build_assets_params(args, :buying_asset)
  end
end
