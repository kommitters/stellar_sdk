defmodule Stellar.Horizon.PathsTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.{Paths, Path}

  setup do
    json_body = Horizon.fixture("paths")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Paths{
      records: [
        %Path{
          destination_amount: 5.0,
          destination_asset_code: "BB1",
          destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
          destination_asset_type: "credit_alphanum4",
          path: [
            %{
              asset_code: "XCN",
              asset_issuer: "GCNY5OXYSY4FKHOPT2SPOQZAOEIGXB5LBYW3HVU3OWSTQITS65M5RCNY",
              asset_type: "credit_alphanum4"
            },
            %{asset_type: "native"}
          ],
          source_amount: 28.9871131,
          source_asset_code: "CNY",
          source_asset_issuer: "GAREELUB43IRHWEASCFBLKHURCGMHE5IF6XSE7EXDLACYHGRHM43RFOX",
          source_asset_type: "credit_alphanum4"
        },
        %Path{
          destination_amount: 5.0,
          destination_asset_code: "BB1",
          destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
          destination_asset_type: "credit_alphanum4",
          path: [
            %{
              asset_code: "ULT",
              asset_issuer: "GC76RMFNNXBFDSJRBXCABWLHXDK4ITVQSMI56DC2ZJVC3YOLLPCKKULT",
              asset_type: "credit_alphanum4"
            },
            %{asset_type: "native"}
          ],
          source_amount: 29.0722784,
          source_asset_code: "CNY",
          source_asset_issuer: "GAREELUB43IRHWEASCFBLKHURCGMHE5IF6XSE7EXDLACYHGRHM43RFOX",
          source_asset_type: "credit_alphanum4"
        }
      ]
    } = Paths.new(attrs[:_embedded])
  end

  test "new/2 empty_attrs" do
    %Paths{records: nil} = Paths.new(%{})
  end
end
