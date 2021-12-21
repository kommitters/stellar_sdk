defmodule Stellar.TxBuild.OptionalAccountIDTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [account_id_xdr: 1]

  alias Stellar.TxBuild.OptionalAccountID
  alias StellarBase.XDR.OptionalAccountID, as: OptionalAccountIdXDR

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      account_id: account_id,
      account_id_xdr: account_id_xdr(account_id)
    }
  end

  test "new/2", %{account_id: account_id} do
    %OptionalAccountID{account_id: ^account_id} = OptionalAccountID.new(account_id)
  end

  test "new/2 without_account_id" do
    %OptionalAccountID{account_id: nil} = OptionalAccountID.new()
  end

  test "to_xdr/1", %{account_id_xdr: account_id_xdr, account_id: account_id} do
    %OptionalAccountIdXDR{account_id: ^account_id_xdr} =
      account_id
      |> OptionalAccountID.new()
      |> OptionalAccountID.to_xdr()
  end

  test "to_xdr/1 without_account_id" do
    %OptionalAccountIdXDR{account_id: nil} =
      nil
      |> OptionalAccountID.new()
      |> OptionalAccountID.to_xdr()
  end
end
