defmodule Stellar.TxBuild.OpValidateTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Account, AccountID, Amount, Asset, AssetsPath, OpValidate}

  setup do
    %{account_id: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"}
  end

  test "validate_account_id/1", %{account_id: account_id} do
    {:ok, %AccountID{}} = OpValidate.validate_account_id({:destination, account_id})
  end

  test "validate_account_id/1 error" do
    {:error, [destination: :invalid_account_id]} =
      OpValidate.validate_account_id({:destination, "ABC"})
  end

  test "validate_account/1", %{account_id: account_id} do
    {:ok, %Account{}} = OpValidate.validate_account({:destination, account_id})
  end

  test "validate_account/1 error" do
    {:error, [destination: :invalid_account_id]} =
      OpValidate.validate_account_id({:destination, "ABC"})
  end

  test "validate_amount/1" do
    {:ok, %Amount{}} = OpValidate.validate_amount({:starting_balance, 100})
  end

  test "validate_amount/1 error" do
    {:error, [starting_balance: :invalid_amount]} =
      OpValidate.validate_amount({:starting_balance, "100"})
  end

  test "validate_asset/1" do
    {:ok, %Asset{}} = OpValidate.validate_asset({:asset, :native})
  end

  test "validate_asset/1 error" do
    {:error, [dest_asset: :invalid_asset_issuer]} =
      OpValidate.validate_asset({:dest_asset, {"BTCN", "ABC"}})
  end

  test "validate_optional_assets_path/1", %{account_id: account_id} do
    {:ok, %AssetsPath{}} =
      OpValidate.validate_optional_assets_path({:path, [:native, {"BTCN", account_id}]})
  end

  test "validate_optional_assets_path/1 empty_list" do
    {:ok, %AssetsPath{assets: []}} = OpValidate.validate_optional_assets_path({:path, nil})
  end

  test "validate_optional_assets_path/1 error" do
    {:error, [path: :invalid_asset_issuer]} =
      OpValidate.validate_optional_assets_path({:path, [:native, {"BTCN", "ABC"}]})
  end
end
