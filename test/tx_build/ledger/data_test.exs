defmodule Stellar.TxBuild.Ledger.DataTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{AccountID, Ledger.Data}

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    data_name = "test"

    %{
      account_id: account_id,
      data_name: data_name,
      xdr: XDRFixtures.ledger_data(account_id, data_name)
    }
  end

  test "new/2", %{account_id: account_id, data_name: data_name} do
    %Data{account_id: %AccountID{account_id: ^account_id}, data_name: ^data_name} =
      Data.new(account_id: account_id, data_name: data_name)
  end

  test "new/2 invalid_account", %{data_name: data_name} do
    {:error, :invalid_account} = Data.new(account_id: "ABCD", data_name: data_name)
  end

  test "new/2 invalid_data", %{account_id: account_id} do
    {:error, :invalid_data_name} =
      Data.new(
        account_id: account_id,
        data_name: "This is a very long and invalid String64 text for Ledger Data entry"
      )
  end

  test "to_xdr/1", %{xdr: xdr, account_id: account_id, data_name: data_name} do
    ^xdr =
      [account_id: account_id, data_name: data_name]
      |> Data.new()
      |> Data.to_xdr()
  end
end
