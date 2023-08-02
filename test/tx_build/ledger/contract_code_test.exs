defmodule Stellar.TxBuild.Ledger.ContractCodeTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Ledger.ContractCode

  setup do
    hash = "ABC123"
    body_type_data_entry = :data_entry
    body_type_expiration_ext = :expiration_ext

    %{
      hash: hash,
      body_type_data_entry: body_type_data_entry,
      body_type_expiration_ext: body_type_expiration_ext
    }
  end

  test "new/1 data_entry", %{hash: hash, body_type_data_entry: body_type} do
    %ContractCode{hash: ^hash, body_type: ^body_type} =
      ContractCode.new(hash: hash, body_type: body_type)
  end

  test "new/1 expiration_ext", %{hash: hash, body_type_expiration_ext: body_type} do
    %ContractCode{hash: ^hash, body_type: ^body_type} =
      ContractCode.new([{:hash, hash}, {:body_type, body_type}])
  end

  test "new/1 with invalid args" do
    {:error, :invalid_ledger_key_args} = ContractCode.new("ABC", "ABC")
  end

  test "to_xdr/1 data_entry", %{hash: hash, body_type_data_entry: body_type} do
    %StellarBase.XDR.LedgerKeyContractCode{
      hash: %StellarBase.XDR.Hash{value: "ABC123"},
      body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :DATA_ENTRY}
    } =
      [{:hash, hash}, {:body_type, body_type}]
      |> ContractCode.new()
      |> ContractCode.to_xdr()
  end

  test "to_xdr/1 expiration_ext", %{hash: hash, body_type_expiration_ext: body_type} do
    %StellarBase.XDR.LedgerKeyContractCode{
      hash: %StellarBase.XDR.Hash{value: "ABC123"},
      body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :EXPIRATION_EXTENSION}
    } =
      [{:hash, hash}, {:body_type, body_type}]
      |> ContractCode.new()
      |> ContractCode.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = ContractCode.to_xdr(%{})
  end
end
