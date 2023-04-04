defmodule Stellar.TxBuild.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{HostFunction, InvokeHostFunction, SCVal}

  import Stellar.Test.XDRFixtures, only: [invoke_host_function_op_xdr: 2]

  describe "InvokeHostFunction" do
    setup do
      type = :invoke
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]

      function =
        HostFunction.new(
          type: type,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )

      footprint =
        "AAAAAgAAAAYEYRaMu64NqWxUO3H9VxrsS0RUnVA/mvnnaFzO28FhPAAAAAMAAAADAAAAB333b6x0UKU606981VsXWEBukqHf/ofD44TsB48KjKRLAAAAAA=="

      %{
        function: function,
        footprint: footprint,
        xdr: invoke_host_function_op_xdr(function, footprint)
      }
    end

    test "new/2", %{
      function: function
    } do
      %InvokeHostFunction{
        function: ^function
      } = InvokeHostFunction.new(function: function)
    end

    test "new/2 with_footprint", %{
      function: function,
      footprint: footprint
    } do
      %InvokeHostFunction{
        function: ^function,
        footprint: ^footprint
      } = InvokeHostFunction.new(function: function, footprint: footprint)
    end

    test "new/2 with_invalid_function" do
      {:error, :invalid_function} = InvokeHostFunction.new(function: "")
    end

    test "new/2 with_invalid_footprint", %{function: function} do
      {:error, :invalid_footprint} = InvokeHostFunction.new(function: function, footprint: 11)
    end

    test "set_footprint", %{function: function, footprint: footprint} do
      %InvokeHostFunction{
        function: ^function,
        footprint: ^footprint
      } =
        [function: function]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.set_footprint(footprint)
    end

    test "to_xdr/1", %{function: function, footprint: footprint, xdr: xdr} do
      ^xdr =
        [function: function, footprint: footprint]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.to_xdr()
    end
  end
end
