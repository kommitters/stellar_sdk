defmodule Stellar.Horizon.Operation.AllowTrustTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.AllowTrust

  setup do
    %{
      attrs: %{
        asset_type: "credit_alphanum4",
        asset_code: "LSV1",
        asset_issuer: "GCRZQVBBDAWVOCO5R2NI34YR55RO2GQXPTDUE5OZESXGZRRTAEQLKEKN",
        trustee: "GCRZQVBBDAWVOCO5R2NI34YR55RO2GQXPTDUE5OZESXGZRRTAEQLKEKN",
        trustor: "GDSYBYRG6NIBJWR7BLY72HYV7VM4A7WWHUJ45FI7H4Q2U2RPR3BB3CFR",
        authorize: true
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        asset_type: asset_type,
        asset_code: asset_code,
        asset_issuer: asset_issuer,
        trustee: trustee,
        trustor: trustor,
        authorize: authorize
      } = attrs
  } do
    %AllowTrust{
      asset_type: ^asset_type,
      asset_code: ^asset_code,
      asset_issuer: ^asset_issuer,
      trustee: ^trustee,
      trustor: ^trustor,
      authorize: ^authorize
    } = AllowTrust.new(attrs)
  end

  test "new/2 empty_attrs" do
    %AllowTrust{
      asset_type: nil,
      asset_code: nil,
      asset_issuer: nil,
      trustee: nil,
      trustor: nil,
      authorize: nil
    } = AllowTrust.new(%{})
  end
end
