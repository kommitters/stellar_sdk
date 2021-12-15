defmodule Stellar.TxBuild.AccountMergeTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [account_merge_op_xdr: 1]

  alias Stellar.TxBuild.{Account, AccountMerge}

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      account_id: account_id,
      destination: Account.new(account_id),
      xdr: account_merge_op_xdr(account_id)
    }
  end

  test "new/2", %{account_id: account_id, destination: destination} do
    %AccountMerge{destination: ^destination} = AccountMerge.new(destination: account_id)
  end

  test "new/2 with_invalid_destination" do
    {:error, [destination: :invalid_account_id]} = AccountMerge.new(destination: "ABC")
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = AccountMerge.new(%{amount: 100})
  end

  test "to_xdr/1", %{xdr: xdr, account_id: account_id} do
    ^xdr =
      [destination: account_id]
      |> AccountMerge.new()
      |> AccountMerge.to_xdr()
  end
end
