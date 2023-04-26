defmodule Stellar.TxBuild.SCContractExecutableTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCContractExecutable, as: TxSCContractExecutable
  alias StellarBase.XDR.{SCContractExecutable, SCContractExecutableType, Hash, Void}

  setup do
    %{
      hash: "example"
    }
  end

  test "new/1 when type is wasm_ref", %{hash: hash} do
    %TxSCContractExecutable{
      type: :wasm_ref,
      value: ^hash
    } = TxSCContractExecutable.new(wasm_ref: hash)
  end

  test "new/1 when type is token" do
    %TxSCContractExecutable{
      type: :token,
      value: nil
    } = TxSCContractExecutable.new(:token)
  end

  test "new/1 with invalid type", %{hash: hash} do
    {:error, :invalid_sc_contract_executable} = TxSCContractExecutable.new(any: hash)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_sc_contract_executable} = TxSCContractExecutable.new("invalid_args")
  end

  test "new/1 with wasm invalid hash" do
    {:error, :invalid_contract_hash} = TxSCContractExecutable.new(wasm_ref: 123)
  end

  test "to_xdr/1 with type is wasm_ref", %{hash: hash} do
    %SCContractExecutable{
      contract_executable: %Hash{value: ^hash},
      type: %SCContractExecutableType{
        identifier: :SCCONTRACT_EXECUTABLE_WASM_REF
      }
    } = TxSCContractExecutable.new(wasm_ref: hash) |> TxSCContractExecutable.to_xdr()
  end

  test "to_xdr/1 with type is token" do
    %SCContractExecutable{
      contract_executable: %Void{value: nil},
      type: %SCContractExecutableType{identifier: :SCCONTRACT_EXECUTABLE_TOKEN}
    } = TxSCContractExecutable.new(:token) |> TxSCContractExecutable.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_sc_contract_executable} = TxSCContractExecutable.to_xdr("invalid_struct")
  end
end
