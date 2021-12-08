defmodule Stellar.TxBuild.CreateAccountTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [create_account_op_xdr: 2]

  alias Stellar.TxBuild.{AccountID, Amount, CreateAccount}

  setup do
    public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    amount = 100

    %{
      public_key: public_key,
      amount: amount,
      destination: AccountID.new(public_key),
      starting_balance: Amount.new(amount),
      xdr: create_account_op_xdr(public_key, amount)
    }
  end

  test "new/2", %{
    public_key: public_key,
    destination: destination,
    starting_balance: starting_balance,
    amount: amount
  } do
    %CreateAccount{destination: ^destination, starting_balance: ^starting_balance} =
      CreateAccount.new(destination: public_key, starting_balance: amount)
  end

  test "new/2 with_invalid_destination", %{amount: amount} do
    {:error, :invalid_destination} = CreateAccount.new(destination: "ABC", starting_balance: amount)
  end

  test "new/2 with_invalid_amount", %{public_key: public_key} do
    {:error, :invalid_starting_balance} = CreateAccount.new(destination: public_key, starting_balance: "123")
  end

  test "to_xdr/1", %{xdr: xdr, public_key: public_key, amount: amount} do
    ^xdr =
      [destination: public_key, starting_balance: amount]
      |> CreateAccount.new()
      |> CreateAccount.to_xdr()
  end
end
