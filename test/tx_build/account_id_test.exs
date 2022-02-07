defmodule Stellar.TxBuild.AccountIDTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [account_id_xdr: 1]
  alias Stellar.TxBuild.AccountID

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      account_id: account_id,
      xdr: account_id_xdr(account_id)
    }
  end

  test "new/2", %{account_id: account_id} do
    %AccountID{account_id: ^account_id} = AccountID.new(account_id)
  end

  test "new/2 invalid_key" do
    {:error, :invalid_account_id} = AccountID.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, account_id: account_id} do
    ^xdr =
      account_id
      |> AccountID.new()
      |> AccountID.to_xdr()
  end
end
