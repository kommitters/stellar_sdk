defmodule Stellar.TxBuild.TrustLineAssetTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{AccountID, PoolID, TrustlineAsset}

  setup do
    code4 = "BTCN"
    code12 = "BTCNEW20000"
    pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"

    %{
      code4: code4,
      code12: code12,
      issuer: issuer,
      pool_id: pool_id,
      native_trustline_xdr: XDRFixtures.trustline_asset(:native),
      alpha_num4_trustline_xdr: XDRFixtures.trustline_asset(code: code4, issuer: issuer),
      alpha_num12_trustline_xdr: XDRFixtures.trustline_asset(code: code12, issuer: issuer),
      pool_share_trustline_xdr: XDRFixtures.trustline_asset(pool_id: pool_id)
    }
  end

  test "new/2 native" do
    %TrustlineAsset{asset: [code: "XLM", issuer: nil], type: :native} =
      TrustlineAsset.new(:native)
  end

  test "new/2 alpha_num4", %{code4: code4, issuer: issuer} do
    %TrustlineAsset{
      asset: [code: ^code4, issuer: %AccountID{account_id: ^issuer}],
      type: :alpha_num4
    } = TrustlineAsset.new(code: code4, issuer: issuer)
  end

  test "new/2 alpha_num12", %{code12: code12, issuer: issuer} do
    %TrustlineAsset{
      asset: [code: ^code12, issuer: %AccountID{account_id: ^issuer}],
      type: :alpha_num12
    } = TrustlineAsset.new(code: code12, issuer: issuer)
  end

  test "new/2 pool_share", %{pool_id: pool_id} do
    %TrustlineAsset{asset: [pool_id: %PoolID{pool_id: ^pool_id}], type: :pool_share} =
      TrustlineAsset.new(pool_id: pool_id)
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_trustline_asset} = TrustlineAsset.new(claimable_balance_id: "test")
  end

  test "new/2 with_invalid_pool_id", %{code4: code4} do
    {:error, :invalid_pool_id} = TrustlineAsset.new(pool_id: code4)
  end

  test "to_xdr/1", %{native_trustline_xdr: xdr} do
    ^xdr =
      :native
      |> TrustlineAsset.new()
      |> TrustlineAsset.to_xdr()
  end

  test "to_xdr/1 alpha_num4", %{alpha_num4_trustline_xdr: xdr, code4: code4, issuer: issuer} do
    ^xdr =
      [code: code4, issuer: issuer]
      |> TrustlineAsset.new()
      |> TrustlineAsset.to_xdr()
  end

  test "to_xdr/1 alpha_num12", %{alpha_num12_trustline_xdr: xdr, code12: code12, issuer: issuer} do
    ^xdr =
      [code: code12, issuer: issuer]
      |> TrustlineAsset.new()
      |> TrustlineAsset.to_xdr()
  end

  test "to_xdr/1 pool_share", %{pool_share_trustline_xdr: xdr, pool_id: pool_id} do
    ^xdr =
      [pool_id: pool_id]
      |> TrustlineAsset.new()
      |> TrustlineAsset.to_xdr()
  end
end
