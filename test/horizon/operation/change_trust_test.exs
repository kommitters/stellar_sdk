defmodule Stellar.Horizon.Operation.ChangeTrustTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.ChangeTrust

  setup do
    %{
      attrs: %{
        asset_type: "credit_alphanum4",
        asset_code: "LSV1",
        limit: "922337203685.4775807",
        limit_f: 922_337_203_685.4775807,
        asset_issuer: "GCRZQVBBDAWVOCO5R2NI34YR55RO2GQXPTDUE5OZESXGZRRTAEQLKEKN",
        trustee: "GCRZQVBBDAWVOCO5R2NI34YR55RO2GQXPTDUE5OZESXGZRRTAEQLKEKN",
        trustor: "GDSYBYRG6NIBJWR7BLY72HYV7VM4A7WWHUJ45FI7H4Q2U2RPR3BB3CFR"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        asset_type: asset_type,
        asset_code: asset_code,
        asset_issuer: asset_issuer,
        limit_f: limit,
        trustee: trustee,
        trustor: trustor
      } = attrs
  } do
    %ChangeTrust{
      asset_type: ^asset_type,
      asset_code: ^asset_code,
      asset_issuer: ^asset_issuer,
      limit: ^limit,
      trustee: ^trustee,
      trustor: ^trustor
    } = ChangeTrust.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ChangeTrust{
      asset_type: nil,
      asset_code: nil,
      asset_issuer: nil,
      trustee: nil,
      trustor: nil,
      liquidity_pool_id: nil
    } = ChangeTrust.new(%{})
  end
end
