defmodule Stellar.TxBuild.InvokeContractArgsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{InvokeContractArgs, SCAddress, SCVal}

  setup do
    fn_args = [SCVal.new(symbol: "dev")]

    contract_address = SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")

    function_name = "hello"

    contract_fn =
      InvokeContractArgs.new(
        contract_address: contract_address,
        function_name: function_name,
        args: fn_args
      )

    xdr = %StellarBase.XDR.InvokeContractArgs{
      contract_address: %StellarBase.XDR.SCAddress{
        sc_address: %StellarBase.XDR.Hash{
          value:
            <<103, 224, 63, 135, 151, 127, 210, 146, 103, 195, 188, 38, 35, 58, 109, 10, 245, 168,
              95, 73, 157, 243, 180, 36, 28, 222, 188, 164, 3, 159, 98, 56>>
        },
        type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_CONTRACT}
      },
      function_name: %StellarBase.XDR.SCSymbol{value: "hello"},
      args: %StellarBase.XDR.SCValList{
        items: [
          %StellarBase.XDR.SCVal{
            value: %StellarBase.XDR.SCSymbol{value: "dev"},
            type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
          }
        ]
      }
    }

    %{
      contract_address: contract_address,
      function_name: function_name,
      fn_args: fn_args,
      contract_fn: contract_fn,
      xdr: xdr
    }
  end

  test "new/2", %{
    contract_address: contract_address,
    function_name: function_name,
    fn_args: fn_args
  } do
    %InvokeContractArgs{
      contract_address: ^contract_address,
      function_name: ^function_name,
      args: ^fn_args
    } =
      InvokeContractArgs.new(
        contract_address: contract_address,
        function_name: function_name,
        args: fn_args
      )
  end

  test "new/2 with invalid contract_address", %{
    function_name: function_name,
    fn_args: fn_args
  } do
    {:error, :invalid_address} =
      InvokeContractArgs.new(
        contract_address: :invalid,
        function_name: function_name,
        args: fn_args
      )
  end

  test "new/2 with invalid function name", %{
    contract_address: contract_address,
    fn_args: fn_args
  } do
    {:error, :invalid_function_name} =
      InvokeContractArgs.new(
        contract_address: contract_address,
        function_name: :invalid,
        args: fn_args
      )
  end

  test "new/2 with invalid function args", %{
    contract_address: contract_address,
    function_name: function_name
  } do
    {:error, :invalid_vals} =
      InvokeContractArgs.new(
        contract_address: contract_address,
        function_name: function_name,
        args: :invalid
      )
  end

  test "new/2 with invalid args" do
    {:error, :invalid_soroban_auth_contract_function_args} = InvokeContractArgs.new(:invalid)
  end

  test "to_xdr/1", %{contract_fn: contract_fn, xdr: xdr} do
    ^xdr = InvokeContractArgs.to_xdr(contract_fn)
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = InvokeContractArgs.to_xdr(:invalid)
  end
end
