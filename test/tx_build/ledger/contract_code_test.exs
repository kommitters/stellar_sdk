defmodule Stellar.TxBuild.Ledger.ContractCodeTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Ledger.ContractCode

  setup do
    hash = "ABC123"

    %{
      hash: hash
    }
  end

  test "new/1 data_entry", %{hash: hash} do
    %ContractCode{hash: ^hash} = ContractCode.new(hash: hash)
  end

  test "new/1 expiration_ext", %{hash: hash} do
    %ContractCode{hash: ^hash} = ContractCode.new([{:hash, hash}])
  end

  test "new/1 with invalid args" do
    {:error, :invalid_ledger_key_args} = ContractCode.new("ABC", "ABC")
  end

  test "to_xdr/1 data_entry", %{hash: hash} do
    %StellarBase.XDR.LedgerKeyContractCode{
      hash: %StellarBase.XDR.Hash{value: "ABC123"}
    } =
      [{:hash, hash}]
      |> ContractCode.new()
      |> ContractCode.to_xdr()
  end

  test "to_xdr/1 expiration_ext", %{hash: hash} do
    %StellarBase.XDR.LedgerKeyContractCode{
      hash: %StellarBase.XDR.Hash{value: "ABC123"}
    } =
      [{:hash, hash}]
      |> ContractCode.new()
      |> ContractCode.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = ContractCode.to_xdr(%{})
  end
end
