defmodule Stellar.TxBuild.OpValidateTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    Account,
    AccountID,
    Amount,
    Asset,
    AssetsPath,
    ClaimableBalanceID,
    OpValidate,
    OptionalAccountID,
    Price
  }

  setup do
    %{
      account_id: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
      balance_id: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    }
  end

  test "validate_pos_integer/1" do
    {:ok, 123} = OpValidate.validate_pos_integer({:offer_id, 123})
  end

  test "validate_pos_integer/1 error" do
    {:error, [offer_id: :integer_expected]} = OpValidate.validate_pos_integer({:offer_id, "123"})
  end

  test "validate_account_id/1", %{account_id: account_id} do
    {:ok, %AccountID{}} = OpValidate.validate_account_id({:destination, account_id})
  end

  test "validate_account_id/1 error" do
    {:error, [destination: :invalid_account_id]} =
      OpValidate.validate_account_id({:destination, "ABC"})
  end

  test "validate_optional_account_id/1", %{account_id: account_id} do
    {:ok, %OptionalAccountID{}} =
      OpValidate.validate_optional_account_id({:destination, account_id})
  end

  test "validate_optional_account_id/1 none" do
    {:ok, %OptionalAccountID{account_id: nil}} =
      OpValidate.validate_optional_account_id({:destination, nil})
  end

  test "validate_optional_account_id/1 error" do
    {:error, [destination: :invalid_account_id]} =
      OpValidate.validate_optional_account_id({:destination, "2"})
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

  test "validate_optional_amount/1" do
    {:ok, %Amount{}} = OpValidate.validate_optional_amount({:trust_limit, 100})
  end

  test "validate_optional_amount/1 none" do
    {:ok, %Amount{raw: 0x7FFFFFFFFFFFFFFF}} =
      OpValidate.validate_optional_amount({:trust_limit, nil})
  end

  test "validate_optional_amount/1 error" do
    {:error, [trust_limit: :invalid_amount]} =
      OpValidate.validate_optional_amount({:trust_limit, "2"})
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

  test "validate_price/1" do
    {:ok, %Price{}} = OpValidate.validate_price({:price, 2.15})
  end

  test "validate_price/1 error" do
    {:error, [price: :invalid_price]} = OpValidate.validate_price({:price, "2.15"})
  end

  test "validate_claimable_balance_id/1", %{balance_id: balance_id} do
    {:ok, %ClaimableBalanceID{}} =
      OpValidate.validate_claimable_balance_id({:claimable_balance_id, balance_id})
  end

  test "validate_claimable_balance_id/1 error" do
    {:error, [claimable_balance_id: :invalid_balance_id]} =
      OpValidate.validate_claimable_balance_id({:claimable_balance_id, "ABC"})
  end
end
