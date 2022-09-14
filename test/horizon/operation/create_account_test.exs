defmodule Stellar.Horizon.Operation.CreateAccountTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.CreateAccount

  setup do
    %{
      attrs: %{
        starting_balance: "2.0000000",
        account: "GCVLWV5B3L3YE6DSCCMHLCK7QIB365NYOLQLW3ZKHI5XINNMRLJ6YHVX",
        funder: "GATL3ETTZ3XDGFXX2ELPIKCZL7S5D2HY3VK4T7LRPD6DW5JOLAEZSZBA"
      }
    }
  end

  test "new/2", %{
    attrs: %{starting_balance: starting_balance, account: account, funder: funder} = attrs
  } do
    %CreateAccount{starting_balance: ^starting_balance, account: ^account, funder: ^funder} =
      CreateAccount.new(attrs)
  end

  test "new/2 empty_attrs" do
    %CreateAccount{starting_balance: nil, account: nil, funder: nil} = CreateAccount.new(%{})
  end
end
