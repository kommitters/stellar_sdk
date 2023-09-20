defmodule Stellar.TxBuild.ValidationsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCVec

  alias Stellar.TxBuild.{
    Account,
    AccountID,
    Amount,
    Asset,
    AssetsPath,
    ClaimableBalanceID,
    Validations,
    OptionalAccountID,
    SCAddress,
    SequenceNumber,
    PoolID,
    Price,
    SCVal
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

  test "validate_sequence_number/1" do
    seq_number = SequenceNumber.new()
    {:ok, ^seq_number} = Validations.validate_sequence_number({:seq_number, seq_number})
  end

  test "validate_sequence_number/1 error" do
    {:error, :invalid_seq_number} = Validations.validate_sequence_number({:seq_number, "invalid"})
  end

  test "validate_address" do
    address = SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")
    {:ok, ^address} = Validations.validate_address(address)
  end

  test "validate_address error" do
    {:error, :invalid_address} = Validations.validate_address(:invalid)
  end

  test "validate_vec" do
    vec = SCVec.new([])
    {:ok, ^vec} = Validations.validate_vec(vec)
  end

  test "validate_vec error" do
    {:error, :invalid_args} = Validations.validate_vec(:invalid)
  end

  test "validate_sc_vals/1" do
    sc_val = %SCVal{type: :int64, value: 42}
    {:ok, [%SCVal{type: :int64, value: 42}]} = Validations.validate_sc_vals({:vals, [sc_val]})
  end

  test "validate_sc_vals/1 error invalid vals" do
    {:error, :invalid_vals} = Validations.validate_sc_vals({:vals, ["invalid"]})
  end

  test "validate_sc_vals/1 error no list" do
    {:error, :invalid_vals} = Validations.validate_sc_vals({:vals, :invalid})
  end

  test "validate_contract_id/1" do
    contract_id = "26a7dec13192736d5ba23c2052fa149021601fc264bc4311fece431ffd388a5c"
    {:ok, ^contract_id} = Validations.validate_contract_id({:contract_id, contract_id})
  end

  test "validate_contract_id/1 error binary size" do
    {:error, :invalid_contract_id} = Validations.validate_contract_id({:contract_id, "invalid"})
  end

  test "validate_contract_id/1 error no binary" do
    {:error, :invalid_contract_id} = Validations.validate_contract_id({:contract_id, 123})
  end

  test "validate_string/1" do
    {:ok, "Hello, World!"} = Validations.validate_string({:str, "Hello, World!"})
  end

  test "validate_string/1 error" do
    {:error, :invalid_str} = Validations.validate_string({:str, 123})
  end
end
