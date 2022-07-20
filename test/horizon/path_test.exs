defmodule Stellar.Horizon.PathTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Path

  setup do
    json_body = Horizon.fixture("path")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Path{
      destination_amount: 5.0,
      destination_asset_code: "BB1",
      destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
      destination_asset_type: "credit_alphanum4",
      path: [
        %{
          asset_code: "NGNT",
          asset_issuer: "GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD",
          asset_type: "credit_alphanum4"
        },
        %{asset_type: "native"}
      ],
      source_amount: 4.1900246,
      source_asset_code: "USD",
      source_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
      source_asset_type: "credit_alphanum4"
    } = Path.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Path{
      destination_amount: nil,
      destination_asset_code: nil,
      destination_asset_issuer: nil,
      destination_asset_type: nil,
      path: nil,
      source_amount: nil,
      source_asset_code: nil,
      source_asset_issuer: nil,
      source_asset_type: nil
    } = Path.new(%{})
  end
end
