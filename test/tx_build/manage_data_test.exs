defmodule Stellar.TxBuild.ManageDataTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [manage_data_op_xdr: 2]

  alias Stellar.TxBuild.ManageData

  setup do
    %{
      entry_name: "NAME",
      entry_value: "VALUE",
      xdr: manage_data_op_xdr("NAME", "VALUE")
    }
  end

  test "new/2", %{entry_name: entry_name, entry_value: entry_value} do
    %ManageData{entry_name: ^entry_name, entry_value: ^entry_value} =
      ManageData.new(entry_name: entry_name, entry_value: entry_value)
  end

  test "new/2 with_empty_value", %{entry_name: entry_name} do
    %ManageData{entry_name: ^entry_name, entry_value: nil} =
      ManageData.new(entry_name: entry_name)
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = ManageData.new("NAME", "VALUE")
  end

  test "to_xdr/1", %{xdr: xdr, entry_name: entry_name, entry_value: entry_value} do
    ^xdr =
      [entry_name: entry_name, entry_value: entry_value]
      |> ManageData.new()
      |> ManageData.to_xdr()
  end

  test "to_xdr/1 empty_value", %{entry_name: entry_name} do
    xdr = manage_data_op_xdr("NAME", nil)

    ^xdr =
      [entry_name: entry_name]
      |> ManageData.new()
      |> ManageData.to_xdr()
  end
end
