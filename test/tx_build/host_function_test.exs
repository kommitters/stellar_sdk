defmodule Stellar.TxBuild.HostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{HostFunction, SCVal}

  describe "HostFunction invoke function" do
    setup do
      type = :invoke
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]

      %{
        type: type,
        contract_id: contract_id,
        function_name: function_name,
        args: args
      }
    end

    test "new/2", %{
      type: type,
      contract_id: contract_id,
      function_name: function_name,
      args: args
    } do
      %HostFunction{
        type: ^type,
        contract_id: ^contract_id,
        function_name: ^function_name,
        args: ^args
      } =
        HostFunction.new(
          type: type,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )
    end
  end
end
