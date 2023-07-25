defmodule Stellar.TxBuild.SorobanAuthorizedInvocationTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCVec,
    SCVal,
    SCAddress,
    SorobanAuthorizedContractFunction,
    SorobanAuthorizedFunction,
    SorobanAuthorizedInvocation
  }

  setup do
    fn_args = SCVec.new([SCVal.new(symbol: "dev")])

    contract_address = SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")

    function_name = "hello"

    contract_fn =
      SorobanAuthorizedContractFunction.new(
        contract_address: contract_address,
        function_name: function_name,
        args: fn_args
      )

    soroban_function = SorobanAuthorizedFunction.new(contract_fn: contract_fn)

    sub_invocations = [
      SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [])
    ]

    auth_invocation_xdr = %StellarBase.XDR.SorobanAuthorizedInvocation{
      function: %StellarBase.XDR.SorobanAuthorizedFunction{
        value: %StellarBase.XDR.SorobanAuthorizedContractFunction{
          contract_address: %StellarBase.XDR.SCAddress{
            sc_address: %StellarBase.XDR.Hash{
              value:
                <<103, 224, 63, 135, 151, 127, 210, 146, 103, 195, 188, 38, 35, 58, 109, 10, 245,
                  168, 95, 73, 157, 243, 180, 36, 28, 222, 188, 164, 3, 159, 98, 56>>
            },
            type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_CONTRACT}
          },
          function_name: %StellarBase.XDR.SCSymbol{value: "hello"},
          args: %StellarBase.XDR.SCVec{
            items: [
              %StellarBase.XDR.SCVal{
                value: %StellarBase.XDR.SCSymbol{value: "dev"},
                type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
              }
            ]
          }
        },
        type: %StellarBase.XDR.SorobanAuthorizedFunctionType{
          identifier: :SOROBAN_AUTHORIZED_FUNCTION_TYPE_CONTRACT_FN
        }
      },
      sub_invocations: %StellarBase.XDR.SorobanAuthorizedInvocationList{items: []}
    }

    %{
      soroban_function: soroban_function,
      sub_invocations: sub_invocations,
      auth_invocation_xdr: auth_invocation_xdr
    }
  end

  test "new/2", %{soroban_function: soroban_function} do
    %SorobanAuthorizedInvocation{
      function: ^soroban_function,
      sub_invocations: []
    } = SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [])
  end

  test "new/2 with sub invocations", %{
    soroban_function: soroban_function,
    sub_invocations: sub_invocations
  } do
    %SorobanAuthorizedInvocation{
      function: ^soroban_function,
      sub_invocations: ^sub_invocations
    } =
      SorobanAuthorizedInvocation.new(
        function: soroban_function,
        sub_invocations: sub_invocations
      )
  end

  test "new/2 invalid function" do
    {:error, :invalid_function} =
      SorobanAuthorizedInvocation.new(function: :invalid, sub_invocations: [])
  end

  test "new/2 invalid sub_invocations", %{soroban_function: soroban_function} do
    {:error, :invalid_sub_invocations} =
      SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [:invalid])
  end

  test "new/2 invalid args" do
    {:error, :invalid_soroban_auth_invocation} = SorobanAuthorizedInvocation.new(:invalid)
  end

  test "to_xdr/1", %{soroban_function: soroban_function, auth_invocation_xdr: auth_invocation_xdr} do
    ^auth_invocation_xdr =
      SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [])
      |> SorobanAuthorizedInvocation.to_xdr()
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SorobanAuthorizedInvocation.to_xdr(:invalid)
  end
end
