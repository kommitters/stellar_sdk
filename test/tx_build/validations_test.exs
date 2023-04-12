defmodule Stellar.TxBuild.ValidationsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SequenceNumber

  alias Stellar.TxBuild.{
    Account,
    AccountID,
    AddressWithNonce,
    Amount,
    Asset,
    AssetsPath,
    ClaimableBalanceID,
    Validations,
    OptionalAccountID,
    OptionalAddressWithNonce,
    SCAddress,
    PoolID,
    Price
  }

  setup do
    %{
      account_id: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
      balance_id: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
      pool_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    }
  end

  test "validate_pos_integer/1" do
    {:ok, 123} = Validations.validate_pos_integer({:offer_id, 123})
  end

  test "validate_pos_integer/1 error" do
    {:error, [offer_id: :integer_expected]} = Validations.validate_pos_integer({:offer_id, "123"})
  end

  test "validate_account_id/1", %{account_id: account_id} do
    {:ok, %AccountID{}} = Validations.validate_account_id({:destination, account_id})
  end

  test "validate_account_id/1 error" do
    {:error, [destination: :invalid_ed25519_public_key]} =
      Validations.validate_account_id({:destination, "ABC"})
  end

  test "validate_optional_account_id/1", %{account_id: account_id} do
    {:ok, %OptionalAccountID{}} =
      Validations.validate_optional_account_id({:destination, account_id})
  end

  test "validate_optional_account_id/1 none" do
    {:ok, %OptionalAccountID{account_id: nil}} =
      Validations.validate_optional_account_id({:destination, nil})
  end

  test "validate_optional_account_id/1 error" do
    {:error, [destination: :invalid_ed25519_public_key]} =
      Validations.validate_optional_account_id({:destination, "2"})
  end

  test "validate_account/1", %{account_id: account_id} do
    {:ok, %Account{}} = Validations.validate_account({:destination, account_id})
  end

  test "validate_account/1 error" do
    {:error, [destination: :invalid_ed25519_public_key]} =
      Validations.validate_account_id({:destination, "ABC"})
  end

  test "validate_amount/1" do
    {:ok, %Amount{}} = Validations.validate_amount({:starting_balance, 100})
  end

  test "validate_amount/1 error" do
    {:error, [starting_balance: :invalid_amount]} =
      Validations.validate_amount({:starting_balance, "100"})
  end

  test "validate_optional_amount/1" do
    {:ok, %Amount{}} = Validations.validate_optional_amount({:trust_limit, 100})
  end

  test "validate_optional_amount/1 none" do
    {:ok, %Amount{raw: 0x7FFFFFFFFFFFFFFF}} =
      Validations.validate_optional_amount({:trust_limit, nil})
  end

  test "validate_optional_amount/1 error" do
    {:error, [trust_limit: :invalid_amount]} =
      Validations.validate_optional_amount({:trust_limit, "2"})
  end

  test "validate_asset/1" do
    {:ok, %Asset{}} = Validations.validate_asset({:asset, :native})
  end

  test "validate_asset/1 error" do
    {:error, [dest_asset: :invalid_asset_issuer]} =
      Validations.validate_asset({:dest_asset, {"BTCN", "ABC"}})
  end

  test "validate_optional_assets_path/1", %{account_id: account_id} do
    {:ok, %AssetsPath{}} =
      Validations.validate_optional_assets_path({:path, [:native, {"BTCN", account_id}]})
  end

  test "validate_optional_assets_path/1 empty_list" do
    {:ok, %AssetsPath{assets: []}} = Validations.validate_optional_assets_path({:path, nil})
  end

  test "validate_optional_assets_path/1 error" do
    {:error, [path: :invalid_asset_issuer]} =
      Validations.validate_optional_assets_path({:path, [:native, {"BTCN", "ABC"}]})
  end

  test "validate_price/1" do
    {:ok, %Price{}} = Validations.validate_price({:price, 2.15})
  end

  test "validate_price/1 error" do
    {:error, [price: :invalid_price]} = Validations.validate_price({:price, "2.15"})
  end

  test "validate_claimable_balance_id/1", %{balance_id: balance_id} do
    {:ok, %ClaimableBalanceID{}} =
      Validations.validate_claimable_balance_id({:claimable_balance_id, balance_id})
  end

  test "validate_claimable_balance_id/1 error" do
    {:error, [claimable_balance_id: :invalid_balance_id]} =
      Validations.validate_claimable_balance_id({:claimable_balance_id, "ABC"})
  end

  test "validate_pool_id/1", %{pool_id: pool_id} do
    {:ok, %PoolID{}} = Validations.validate_pool_id({:liquidity_pool_id, pool_id})
  end

  test "validate_pool_id/1 error" do
    {:error, [liquidity_pool_id: :invalid_pool_id]} =
      Validations.validate_pool_id({:liquidity_pool_id, "ABC"})
  end

  test "validate_optional_address_with_nonce/1", %{account_id: account_id} do
    address_with_nonce =
      AddressWithNonce.new(address: SCAddress.new(account: account_id), nonce: 123)

    {:ok, %OptionalAddressWithNonce{}} =
      Validations.validate_optional_address_with_nonce({:address_with_nonce, address_with_nonce})
  end

  test "validate_optional_address_with_nonce/1 error" do
    {:error, :invalid_address_with_nonce} =
      Validations.validate_optional_address_with_nonce({:address_with_nonce, "invalid"})
  end

  test "validate_sequence_number/1" do
    seq_number = SequenceNumber.new()
    {:ok, ^seq_number} = Validations.validate_sequence_number({:seq_number, seq_number})
  end

  test "validate_sequence_number/1 error" do
    {:error, :invalid_seq_number} = Validations.validate_sequence_number({:seq_number, "invalid"})
  end
end
