defmodule Stellar.TxBuild.AccountTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.Account

  setup do
    account_id = "GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH"
    muxed_address = "MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPQ"

    %{
      account_id: account_id,
      muxed_address: muxed_address,
      muxed_account_xdr: XDRFixtures.muxed_account(account_id),
      muxed_account_med25519_xdr: XDRFixtures.muxed_account_med25519(muxed_address)
    }
  end

  describe "new/2" do
    test "ed25519_public_key", %{account_id: account_id} do
      %Account{address: ^account_id, account_id: ^account_id, type: :ed25519_public_key} =
        Account.new(account_id)
    end

    test "muxed_account", %{muxed_address: muxed_address, account_id: account_id} do
      %Account{
        address: ^muxed_address,
        account_id: ^account_id,
        muxed_id: 4,
        type: :ed25519_muxed_account
      } = Account.new(muxed_address)
    end

    test "invalid_ed25519_public_key" do
      {:error, :invalid_ed25519_public_key} =
        Account.new("GAAAAA2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH")
    end

    test "invalid_muxed_account" do
      {:error, :invalid_ed25519_muxed_account} =
        Account.new("MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPD")
    end

    test "invalid_key" do
      {:error, :invalid_ed25519_public_key} = Account.new("ABCD")
    end
  end

  describe "to_xdr/1" do
    test "ed25519_public_key", %{muxed_account_xdr: xdr, account_id: account_id} do
      ^xdr =
        account_id
        |> Account.new()
        |> Account.to_xdr()
    end

    test "muxed_account", %{muxed_account_med25519_xdr: xdr, muxed_address: muxed_address} do
      ^xdr =
        muxed_address
        |> Account.new()
        |> Account.to_xdr()
    end
  end

  describe "create_muxed/2" do
    test "success", %{muxed_address: muxed_address, account_id: account_id} do
      %Account{
        address: ^muxed_address,
        account_id: ^account_id,
        muxed_id: 4,
        type: :ed25519_muxed_account
      } = Account.create_muxed(account_id, 4)
    end

    test "invalid_attribute", %{account_id: account_id} do
      {:error, :invalid_muxed_account} = Account.create_muxed(account_id, "123")
    end
  end
end
