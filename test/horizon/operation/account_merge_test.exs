defmodule Stellar.Horizon.Operation.AccountMergeTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.AccountMerge

  setup do
    %{
      attrs: %{
        account: "GCVLWV5B3L3YE6DSCCMHLCK7QIB365NYOLQLW3ZKHI5XINNMRLJ6YHVX",
        into: "GATL3ETTZ3XDGFXX2ELPIKCZL7S5D2HY3VK4T7LRPD6DW5JOLAEZSZBA"
      }
    }
  end

  test "new/2", %{attrs: %{account: account, into: into} = attrs} do
    %AccountMerge{account: ^account, into: ^into} = AccountMerge.new(attrs)
  end

  test "new/2 empty_attrs" do
    %AccountMerge{account: nil, into: nil} = AccountMerge.new(%{})
  end
end
