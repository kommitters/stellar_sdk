defmodule Stellar.TxBuild.HostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    ContractExecutable,
    ContractIDPreimage,
    ContractIDPreimageFromAddress,
    CreateContractArgs,
    HostFunction,
    SCAddress,
    SCVal,
    SCVec,
    VariableOpaque
  }

  import Stellar.Test.XDRFixtures,
    only: [host_function_xdr: 2]

  describe "HostFunction" do
    setup do
      # :invoke_contract
      contract_address =
        "CACGCFUMXOXA3KLMKQ5XD7KXDLWEWRCUTVID7GXZ45UFZTW3YFQTZD6Y"
        |> SCAddress.new()
        |> (&SCVal.new(address: &1)).()

      function_name = SCVal.new(symbol: "hello")
      invoke_args = SCVec.new([contract_address, function_name, SCVal.new(symbol: "world")])

      # :create_contract
      wasm_id =
        <<86, 32, 6, 9, 172, 4, 212, 185, 249, 87, 184, 164, 58, 34, 167, 183, 226, 117, 205, 116,
          11, 130, 119, 172, 224, 51, 12, 148, 90, 251, 17, 12>>

      contract_executable = ContractExecutable.new(wasm_ref: wasm_id)
      sc_address = SCAddress.new("GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN")
      # :crypto.strong_rand_bytes(32)
      salt =
        <<142, 226, 180, 159, 151, 224, 223, 135, 33, 210, 154, 238, 13, 199, 60, 77, 67, 167,
          216, 125, 245, 241, 237, 114, 207, 74, 226, 98, 166, 200, 43, 89>>

      from_address = ContractIDPreimageFromAddress.new(address: sc_address, salt: salt)
      contract_id_preimage = ContractIDPreimage.new(from_address: from_address)

      create_contract_args =
        CreateContractArgs.new(
          contract_id_preimage: contract_id_preimage,
          contract_executable: contract_executable
        )

      # :upload_contract_wasm
      code =
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 19, 4, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          1, 127, 0, 96, 0, 0, 2, 37, 6, 1, 118, 1, 95, 0, 0, 1, 118, 1, 54, 0, 1, 1, 97, 1, 48,
          0, 0, 1, 108, 1, 48, 0, 0>>

      upload_contract_wasm_args = VariableOpaque.new(code)

      %{
        invoke_args: invoke_args,
        invoke_host_function: HostFunction.new(invoke_contract: invoke_args),
        host_function_xdr: host_function_xdr(:invoke_contract, invoke_args),
        create_contract_args: create_contract_args,
        create_contract_function: HostFunction.new(create_contract: create_contract_args),
        create_contract_xdr: host_function_xdr(:create_contract, create_contract_args),
        upload_contract_wasm_args: upload_contract_wasm_args,
        upload_contract_wasm_function:
          HostFunction.new(upload_contract_wasm: upload_contract_wasm_args),
        upload_contract_wasm_xdr:
          host_function_xdr(:upload_contract_wasm, upload_contract_wasm_args)
      }
    end

    test "new/2 invoke_contract", %{
      invoke_args: invoke_args
    } do
      %HostFunction{
        type: :invoke_contract,
        value: ^invoke_args
      } = HostFunction.new(invoke_contract: invoke_args)
    end

    test "new/2 create_contract", %{
      create_contract_args: create_contract_args
    } do
      %HostFunction{
        type: :create_contract,
        value: ^create_contract_args
      } = HostFunction.new(create_contract: create_contract_args)
    end

    test "new/2 upload_contract_wasm", %{
      upload_contract_wasm_args: upload_contract_wasm_args
    } do
      %HostFunction{
        type: :upload_contract_wasm,
        value: ^upload_contract_wasm_args
      } = HostFunction.new(upload_contract_wasm: upload_contract_wasm_args)
    end

    test "new/2 invalid attributes" do
      {:error, :invalid_operation_attributes} = HostFunction.new(:invalid)
    end

    test "new/2 invalid host function value" do
      {:error, :invalid_create_contract} = HostFunction.new(create_contract: :invalid)
    end

    test "to_xdr/1 invoke_contract", %{
      host_function_xdr: host_function_xdr,
      invoke_host_function: invoke_host_function
    } do
      ^host_function_xdr = HostFunction.to_xdr(invoke_host_function)
    end

    test "to_xdr/1 create_contract", %{
      create_contract_xdr: create_contract_xdr,
      create_contract_function: create_contract_function
    } do
      ^create_contract_xdr = HostFunction.to_xdr(create_contract_function)
    end

    test "to_xdr/1 upload_contract_wasm", %{
      upload_contract_wasm_xdr: upload_contract_wasm_xdr,
      upload_contract_wasm_function: upload_contract_wasm_function
    } do
      ^upload_contract_wasm_xdr = HostFunction.to_xdr(upload_contract_wasm_function)
    end
  end
end
