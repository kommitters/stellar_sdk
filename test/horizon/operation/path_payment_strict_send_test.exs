defmodule Stellar.Horizon.Operation.PathPaymentStrictSendTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.PathPaymentStrictSend

  setup do
    %{
      attrs: %{
        asset_type: "credit_alphanum4",
        asset_code: "BRL",
        asset_issuer: "GDVKY2GU2DRXWTBEYJJWSFXIGBZV6AZNBVVSUHEPZI54LIS6BA7DVVSP",
        from: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z",
        to: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z",
        amount: "0.1000000",
        path: [
          %{
            asset_type: "credit_alphanum4",
            asset_code: "USD",
            asset_issuer: "GBUYUAI75XXWDZEKLY66CFYKQPET5JR4EENXZBUZ3YXZ7DS56Z4OKOFU"
          },
          %{
            asset_type: "native"
          }
        ],
        source_amount: "0.0198773",
        destination_min: "0.0198774",
        source_asset_type: "credit_alphanum4",
        source_asset_code: "USD",
        source_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        asset_type: asset_type,
        asset_code: asset_code,
        asset_issuer: asset_issuer,
        from: from,
        to: to,
        path: path,
        source_asset_type: source_asset_type,
        source_asset_code: source_asset_code,
        source_asset_issuer: source_asset_issuer
      } = attrs
  } do
    %PathPaymentStrictSend{
      asset_type: ^asset_type,
      asset_code: ^asset_code,
      asset_issuer: ^asset_issuer,
      from: ^from,
      to: ^to,
      amount: 0.1,
      path: ^path,
      source_amount: 0.0198773,
      destination_min: 0.0198774,
      source_asset_type: ^source_asset_type,
      source_asset_code: ^source_asset_code,
      source_asset_issuer: ^source_asset_issuer
    } = PathPaymentStrictSend.new(attrs)
  end

  test "new/2 empty_attrs" do
    %PathPaymentStrictSend{
      asset_type: nil,
      asset_code: nil,
      asset_issuer: nil,
      from: nil,
      to: nil,
      amount: nil,
      path: nil,
      source_amount: nil,
      destination_min: nil,
      source_asset_type: nil,
      source_asset_code: nil,
      source_asset_issuer: nil
    } = PathPaymentStrictSend.new(%{})
  end
end
