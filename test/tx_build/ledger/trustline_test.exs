defmodule Stellar.TxBuild.Ledger.TrustlineTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{AccountID, TrustlineAsset, Ledger.Trustline}

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    issuer = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    alphanum4_asset = [code: "BTCN", issuer: issuer]
    alphanum12_asset = [code: "BTCNEW2000", issuer: issuer]
    pool_share_asset = [pool_id: pool_id]

    %{
      account_id: account_id,
      native_asset: :native,
      alphanum4_asset: alphanum4_asset,
      alphanum12_asset: alphanum12_asset,
      pool_share_asset: pool_share_asset,
      native_trustline_xdr: XDRFixtures.ledger_trustline(account_id, :native),
      alphanum4_trustline_xdr: XDRFixtures.ledger_trustline(account_id, alphanum4_asset),
      alphanum12_trustline_xdr: XDRFixtures.ledger_trustline(account_id, alphanum12_asset),
      pool_share_trustline_xdr: XDRFixtures.ledger_trustline(account_id, pool_share_asset)
    }
  end

  test "new/2", %{account_id: account_id, native_asset: native_asset} do
    %Trustline{
      account_id: %AccountID{account_id: ^account_id},
      asset: %TrustlineAsset{type: :native}
    } = Trustline.new(account_id: account_id, asset: native_asset)
  end

  test "new/2 with_alphanum4_asset", %{account_id: account_id, alphanum4_asset: alphanum4_asset} do
    %Trustline{
      account_id: %AccountID{account_id: ^account_id},
      asset: %TrustlineAsset{type: :alpha_num4}
    } = Trustline.new(account_id: account_id, asset: alphanum4_asset)
  end

  test "new/2 with_alphanum12_asset", %{
    account_id: account_id,
    alphanum12_asset: alphanum12_asset
  } do
    %Trustline{
      account_id: %AccountID{account_id: ^account_id},
      asset: %TrustlineAsset{type: :alpha_num12}
    } = Trustline.new(account_id: account_id, asset: alphanum12_asset)
  end

  test "new/2 with_pool_share_asset", %{
    account_id: account_id,
    pool_share_asset: pool_share_asset
  } do
    %Trustline{
      account_id: %AccountID{account_id: ^account_id},
      asset: %TrustlineAsset{type: :pool_share}
    } = Trustline.new(account_id: account_id, asset: pool_share_asset)
  end

  test "new/2 with_invalid_account", %{alphanum4_asset: alphanum4_asset} do
    {:error, :invalid_account} = Trustline.new(account_id: "ABCD", asset: alphanum4_asset)
  end

  test "new/2 with_invalid_asset", %{account_id: account_id} do
    {:error, :invalid_asset} = Trustline.new(account_id: account_id, asset: "ABCD")
  end

  test "to_xdr/1", %{native_trustline_xdr: xdr, native_asset: asset, account_id: account_id} do
    ^xdr =
      [account_id: account_id, asset: asset]
      |> Trustline.new()
      |> Trustline.to_xdr()
  end

  test "to_xdr/1 with_alphanum4_asset", %{
    alphanum4_trustline_xdr: xdr,
    alphanum4_asset: asset,
    account_id: account_id
  } do
    ^xdr =
      [account_id: account_id, asset: asset]
      |> Trustline.new()
      |> Trustline.to_xdr()
  end

  test "to_xdr/1 with_alphanum12_asset", %{
    alphanum12_trustline_xdr: xdr,
    alphanum12_asset: asset,
    account_id: account_id
  } do
    ^xdr =
      [account_id: account_id, asset: asset]
      |> Trustline.new()
      |> Trustline.to_xdr()
  end

  test "to_xdr/1 with_pool_share_asset", %{
    pool_share_trustline_xdr: xdr,
    pool_share_asset: asset,
    account_id: account_id
  } do
    ^xdr =
      [account_id: account_id, asset: asset]
      |> Trustline.new()
      |> Trustline.to_xdr()
  end
end
