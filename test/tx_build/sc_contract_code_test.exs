defmodule Stellar.TxBuild.SCContractCodeTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCContractCode, as: TxSCContractCode
  alias StellarBase.XDR.{SCContractCode, SCContractCodeType, Hash, Void}

  setup do
    %{
      hash: "example"
    }
  end

  test "new/1 when type is wasm_ref", %{hash: hash} do
    %TxSCContractCode{
      type: :wasm_ref,
      value: ^hash
    } = TxSCContractCode.new(wasm_ref: hash)
  end

  test "new/1 when type is token", %{hash: hash} do
    %TxSCContractCode{
      type: :token,
      value: ^hash
    } = TxSCContractCode.new(token: hash)
  end

  test "new/1 with invalid type", %{hash: hash} do
    {:error, :invalid_sc_contract_code} = TxSCContractCode.new(any: hash)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_sc_contract_code} = TxSCContractCode.new("invalid_args")
  end

  test "new/1 with wasm invalid hash" do
    {:error, :invalid_contract_hash} = TxSCContractCode.new(wasm_ref: 123)
  end

  test "new/1 with token invalid hash" do
    {:error, :invalid_contract_hash} = TxSCContractCode.new(token: 123)
  end

  test "to_xdr/1 with type is wasm_ref", %{hash: hash} do
    %SCContractCode{
      contract_code: %Hash{value: ^hash},
      type: %SCContractCodeType{
        identifier: :SCCONTRACT_CODE_WASM_REF
      }
    } = TxSCContractCode.new(wasm_ref: hash) |> TxSCContractCode.to_xdr()
  end

  test "to_xdr/1 with type is token", %{hash: hash} do
    %SCContractCode{
      contract_code: %Void{value: nil},
      type: %SCContractCodeType{identifier: :SCCONTRACT_CODE_TOKEN}
    } = TxSCContractCode.new(token: hash) |> TxSCContractCode.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_sc_contract_code} = TxSCContractCode.to_xdr("invalid_struct")
  end
end
