defmodule Stellar.TxBuild.AccountTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [muxed_account_xdr: 1]
  alias Stellar.TxBuild.Account

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      account_id: account_id,
      xdr: muxed_account_xdr(account_id)
    }
  end

  test "new/2", %{account_id: account_id} do
    %Account{account_id: ^account_id} = Account.new(account_id)
  end

  test "new/2 invalid_key" do
    {:error, :invalid_account_id} = Account.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, account_id: account_id} do
    ^xdr =
      account_id
      |> Account.new()
      |> Account.to_xdr()
  end
end
