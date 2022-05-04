defmodule Stellar.TxBuild.Ledger.AccountTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{AccountID, Ledger.Account}

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      account_id: account_id,
      xdr: XDRFixtures.ledger_account(account_id)
    }
  end

  test "new/2", %{account_id: account_id} do
    %Account{account_id: %AccountID{account_id: ^account_id}} = Account.new(account_id)
  end

  test "new/2 invalid_key" do
    {:error, :invalid_ed25519_public_key} = Account.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, account_id: account_id} do
    ^xdr =
      account_id
      |> Account.new()
      |> Account.to_xdr()
  end
end
