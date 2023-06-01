defmodule Stellar.TxBuild.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    HostFunction,
    HostFunctionArgs,
    InvokeHostFunction,
    OptionalAccount,
    SCVal
  }

  import Stellar.Test.XDRFixtures,
    only: [
      invoke_host_function_op_xdr: 1
    ]

  describe "InvokeHostFunction" do
    setup do
      type = :invoke
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]
      source_account = "GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN"

      function_args =
        HostFunctionArgs.new(
          type: type,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )

      host_functions = [HostFunction.new(args: function_args)]

      %{
        host_functions: host_functions,
        source_account: source_account,
        invoke_host_function: InvokeHostFunction.new(functions: host_functions),
        xdr: invoke_host_function_op_xdr(host_functions)
      }
    end

    test "new/2", %{host_functions: host_functions} do
      %InvokeHostFunction{
        functions: ^host_functions
      } = InvokeHostFunction.new(functions: host_functions)
    end

    test "new/2 with source_account", %{
      host_functions: host_functions,
      source_account: source_account
    } do
      %InvokeHostFunction{
        functions: ^host_functions,
        source_account: %OptionalAccount{
          account_id: ^source_account
        }
      } =
        InvokeHostFunction.new(
          functions: host_functions,
          source_account: source_account
        )
    end

    test "new/2 invalid attributes" do
      {:error, :invalid_operation_attributes} = InvokeHostFunction.new("invalid")
    end

    test "new/2 invalid host function" do
      {:error, :invalid_host_function_list} = InvokeHostFunction.new(functions: [:invalid])
    end

    test "to_xdr/1", %{
      invoke_host_function: invoke_host_function,
      xdr: xdr
    } do
      ^xdr = InvokeHostFunction.to_xdr(invoke_host_function)
    end
  end
end
