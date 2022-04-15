defmodule Stellar.TxBuild.SetTrustlineFlagsTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{AccountID, Asset, SetTrustlineFlags, TrustlineFlags}

  setup do
    trustor = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    asset_code = "BTCN"
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    clear_flags = []
    set_flags = [:authorized, :maintain_liabilities]

    %{
      trustor: trustor,
      asset: {asset_code, asset_issuer},
      clear_flags: clear_flags,
      set_flags: set_flags,
      xdr:
        XDRFixtures.set_trustline_flags(
          trustor,
          {asset_code, asset_issuer},
          set_flags,
          clear_flags
        )
    }
  end

  test "new/2", %{
    trustor: trustor,
    asset: asset,
    set_flags: set_flags
  } do
    trustor_str = AccountID.new(trustor)
    asset_str = Asset.new(asset)
    set_flags_str = set_flags |> TrustlineFlags.new()

    %SetTrustlineFlags{
      trustor: ^trustor_str,
      asset: ^asset_str,
      set_flags: ^set_flags_str
    } =
      SetTrustlineFlags.new(
        trustor: trustor,
        asset: asset,
        set_flags: set_flags
      )
  end

  test "new/2 with_invalid_trustor" do
    {:error, [trustor: :invalid_ed25519_public_key]} =
      SetTrustlineFlags.new(
        asset: :native,
        trustor: "ABC"
      )
  end

  test "new/2 with_invalid_asset", %{trustor: trustor} do
    {:error, [asset: :invalid_asset_issuer]} =
      SetTrustlineFlags.new(
        asset: {"BTCN", "ABC"},
        trustor: trustor
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = SetTrustlineFlags.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    trustor: trustor,
    asset: asset,
    set_flags: set_flags,
    clear_flags: clear_flags
  } do
    ^xdr =
      [trustor: trustor, asset: asset, set_flags: set_flags, clear_flags: clear_flags]
      |> SetTrustlineFlags.new()
      |> SetTrustlineFlags.to_xdr()
  end
end
