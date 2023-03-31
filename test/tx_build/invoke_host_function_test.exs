defmodule Stellar.TxBuild.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{HostFunction, InvokeHostFunction, SCVal}

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

      %{
        function: function
      }
    end

    test "new/2", %{
      function: function
    } do
      %InvokeHostFunction{
        function: ^function
      } = InvokeHostFunction.new(function: function)
    end
  end
end
