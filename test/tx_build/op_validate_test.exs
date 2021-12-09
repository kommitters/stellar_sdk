defmodule Stellar.TxBuild.OpValidateTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Account, AccountID, Amount, OpValidate}

  setup do
    %{account_id: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"}
  end

  test "validate_account_id/2", %{account_id: account_id} do
    {:ok, %AccountID{}} = OpValidate.validate_account_id({:destination, account_id})
  end

  test "validate_account_id/2 error" do
    {:error, [destination: :invalid_account_id]} =
      OpValidate.validate_account_id({:destination, "ABC"})
  end

  test "validate_account/2", %{account_id: account_id} do
    {:ok, %Account{}} = OpValidate.validate_account({:destination, account_id})
  end

  test "validate_account/2 error" do
    {:error, [destination: :invalid_account_id]} =
      OpValidate.validate_account_id({:destination, "ABC"})
  end

  test "validate_amount/2" do
    {:ok, %Amount{}} = OpValidate.validate_amount({:starting_balance, 100})
  end

  test "validate_amount/2 error" do
    {:error, [starting_balance: :invalid_amount]} =
      OpValidate.validate_amount({:starting_balance, "100"})
  end
end
