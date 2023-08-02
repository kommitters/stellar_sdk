defmodule Stellar.TxBuild.LedgerKeyTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{LedgerKey, SCAddress, SCVal}

  alias Stellar.TxBuild.Ledger.{
    Account,
    ClaimableBalance,
    Data,
    LedgerKeyContractCode,
    LedgerKeyContractData,
    LiquidityPool,
    Offer,
    Trustline
  }

  describe "account" do
    setup do
      account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

      %{
        account_id: account_id,
        account: Account.new(account_id),
        xdr: XDRFixtures.ledger_key_account(account_id)
      }
    end

    test "new/2", %{account_id: account_id, account: account} do
      %LedgerKey{entry: ^account, type: :account} =
        LedgerKey.new({:account, [account_id: account_id]})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_account} = LedgerKey.new({:account, [account_id: "ABC"]})
    end

    test "to_xdr/1", %{account_id: account_id, xdr: xdr} do
      ^xdr = LedgerKey.new({:account, [account_id: account_id]}) |> LedgerKey.to_xdr()
    end
  end

  describe "trustline" do
    setup do
      account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

      %{
        account_id: account_id,
        trustline: Trustline.new(account_id: account_id, asset: :native),
        xdr: XDRFixtures.ledger_key_trustline(account_id, :native)
      }
    end

    test "new/2", %{account_id: account_id, trustline: trustline} do
      %LedgerKey{entry: ^trustline, type: :trustline} =
        LedgerKey.new({:trustline, [account_id: account_id, asset: :native]})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_trustline} = LedgerKey.new({:trustline, [account_id: "ABC"]})
    end

    test "to_xdr/1", %{account_id: account_id, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:trustline, [account_id: account_id, asset: :native]})
        |> LedgerKey.to_xdr()
    end
  end

  describe "offer" do
    setup do
      seller_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      offer_id = 123

      %{
        seller_id: seller_id,
        offer_id: offer_id,
        offer: Offer.new(seller_id: seller_id, offer_id: offer_id),
        xdr: XDRFixtures.ledger_key_offer(seller_id, offer_id)
      }
    end

    test "new/2", %{seller_id: seller_id, offer_id: offer_id, offer: offer} do
      %LedgerKey{entry: ^offer, type: :offer} =
        LedgerKey.new({:offer, [seller_id: seller_id, offer_id: offer_id]})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_offer} = LedgerKey.new({:offer, [seller_id: "ABC", offer_id: 123]})
    end

    test "to_xdr/1", %{seller_id: seller_id, offer_id: offer_id, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:offer, [seller_id: seller_id, offer_id: offer_id]})
        |> LedgerKey.to_xdr()
    end
  end

  describe "data" do
    setup do
      account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      data_name = "test"

      %{
        account_id: account_id,
        data_name: data_name,
        data: Data.new(account_id: account_id, data_name: data_name),
        xdr: XDRFixtures.ledger_key_data(account_id, data_name)
      }
    end

    test "new/2", %{account_id: account_id, data_name: data_name, data: data} do
      %LedgerKey{entry: ^data, type: :data} =
        LedgerKey.new({:data, [account_id: account_id, data_name: data_name]})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_data} = LedgerKey.new({:data, [account_id: "ABC", data_name: "test"]})
    end

    test "to_xdr/1", %{account_id: account_id, data_name: data_name, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:data, [account_id: account_id, data_name: data_name]})
        |> LedgerKey.to_xdr()
    end
  end

  describe "claimable_balance" do
    setup do
      claimable_balance_id =
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

      %{
        claimable_balance_id: claimable_balance_id,
        claimable_balance: ClaimableBalance.new(claimable_balance_id),
        xdr: XDRFixtures.ledger_key_claimable_balance(claimable_balance_id)
      }
    end

    test "new/2", %{
      claimable_balance_id: claimable_balance_id,
      claimable_balance: claimable_balance
    } do
      %LedgerKey{entry: ^claimable_balance, type: :claimable_balance} =
        LedgerKey.new({:claimable_balance, [claimable_balance_id: claimable_balance_id]})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_claimable_balance} =
        LedgerKey.new({:claimable_balance, [claimable_balance_id: "ABC"]})
    end

    test "to_xdr/1", %{claimable_balance_id: claimable_balance_id, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:claimable_balance, [claimable_balance_id: claimable_balance_id]})
        |> LedgerKey.to_xdr()
    end
  end

  describe "liquidity_pool" do
    setup do
      liquidity_pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

      %{
        liquidity_pool_id: liquidity_pool_id,
        liquidity_pool: LiquidityPool.new(liquidity_pool_id),
        xdr: XDRFixtures.ledger_key_liquidity_pool(liquidity_pool_id)
      }
    end

    test "new/2", %{
      liquidity_pool_id: liquidity_pool_id,
      liquidity_pool: liquidity_pool
    } do
      %LedgerKey{entry: ^liquidity_pool, type: :liquidity_pool} =
        LedgerKey.new({:liquidity_pool, [liquidity_pool_id: liquidity_pool_id]})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_liquidity_pool} =
        LedgerKey.new({:liquidity_pool, [liquidity_pool_id: "ABC"]})
    end

    test "to_xdr/1", %{liquidity_pool_id: liquidity_pool_id, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:liquidity_pool, [liquidity_pool_id: liquidity_pool_id]})
        |> LedgerKey.to_xdr()
    end
  end

  test "new/2 invalid_ledger_key" do
    {:error, :invalid_ledger_key} = LedgerKey.new({:test, [account_id: "ABC"]})
  end

  describe "contract_data" do
    setup do
      contract = SCAddress.new("CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN")
      key = SCVal.new(ledger_key_contract_instance: nil)
      durability = :persistent
      body_type = :data_entry

      contract_data =
        LedgerKeyContractData.new(
          contract: contract,
          key: key,
          durability: durability,
          body_type: body_type
        )

      contract_data_args = [
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      ]

      %{
        contract_data: contract_data,
        contract_data_args: contract_data_args,
        xdr: XDRFixtures.ledger_key_contract_data()
      }
    end

    test "new/2", %{contract_data: contract_data, contract_data_args: contract_data_args} do
      %LedgerKey{entry: ^contract_data, type: :contract_data} =
        LedgerKey.new({:contract_data, contract_data_args})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_contract_data} = LedgerKey.new({:contract_data, [invalid: "ABC"]})
    end

    test "to_xdr/1", %{contract_data_args: contract_data_args, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:contract_data, contract_data_args})
        |> LedgerKey.to_xdr()
    end
  end

  describe "contract_code" do
    setup do
      hash = "ABC123"
      body_type = :data_entry

      contract_code = LedgerKeyContractCode.new(hash: hash, body_type: body_type)

      contract_code_args = [hash: hash, body_type: body_type]

      %{
        contract_code: contract_code,
        contract_code_args: contract_code_args,
        xdr: XDRFixtures.ledger_key_contract_code()
      }
    end

    test "new/2", %{contract_code: contract_code, contract_code_args: contract_code_args} do
      %LedgerKey{entry: ^contract_code, type: :contract_code} =
        LedgerKey.new({:contract_code, contract_code_args})
    end

    test "new/2 with_invalid_attributes" do
      {:error, :invalid_contract_code} = LedgerKey.new({:contract_code, [invalid: "ABC"]})
    end

    test "to_xdr/1", %{contract_code_args: contract_code_args, xdr: xdr} do
      ^xdr =
        LedgerKey.new({:contract_code, contract_code_args})
        |> LedgerKey.to_xdr()
    end
  end
end
