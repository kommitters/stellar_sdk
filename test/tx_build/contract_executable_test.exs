defmodule Stellar.TxBuild.ContractExecutableTest do
  use ExUnit.Case

  alias Stellar.TxBuild.ContractExecutable, as: TxContractExecutable
  alias StellarBase.XDR.{ContractExecutable, ContractExecutableType, Hash, Void}

  setup do
    %{
      hash: "example"
    }
  end

  test "new/1 when type is wasm_ref", %{hash: hash} do
    %TxContractExecutable{
      type: :wasm_ref,
      value: ^hash
    } = TxContractExecutable.new(wasm_ref: hash)
  end

  test "new/1 when type is stellar_asset" do
    %TxContractExecutable{
      type: :stellar_asset,
      value: nil
    } = TxContractExecutable.new(:stellar_asset)
  end

  test "new/1 with invalid type", %{hash: hash} do
    {:error, :invalid_contract_executable} = TxContractExecutable.new(any: hash)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_contract_executable} = TxContractExecutable.new("invalid_args")
  end

  test "new/1 with wasm invalid hash" do
    {:error, :invalid_contract_executable} = TxContractExecutable.new(wasm_ref: 123)
  end

  test "to_xdr/1 with wasm_ref type", %{hash: hash} do
    %ContractExecutable{
      value: %Hash{value: ^hash},
      type: %ContractExecutableType{
        identifier: :CONTRACT_EXECUTABLE_WASM
      }
    } = TxContractExecutable.new(wasm_ref: hash) |> TxContractExecutable.to_xdr()
  end

  test "to_xdr/1 with stellar_asset type" do
    %ContractExecutable{
      value: %Void{value: nil},
      type: %ContractExecutableType{identifier: :CONTRACT_EXECUTABLE_STELLAR_ASSET}
    } = TxContractExecutable.new(:stellar_asset) |> TxContractExecutable.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = TxContractExecutable.to_xdr("invalid_struct")
  end
end
