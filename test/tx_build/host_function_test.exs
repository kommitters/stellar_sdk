defmodule Stellar.TxBuild.HostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{HostFunction, SCVal}

  describe "invoke contract" do
    setup do
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]

      %{
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        xdr: HostFunction(
          type: :invoke,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )
      }
    end

    test "new/2", %{contract_id: contract_id, function_name: function_name, args: args} do
      %HostFunction{
        type: :invoke,
        contract_id: ^contract_id,
        function_name: ^function_name,
        args: ^args
      } = HostFunction.new(
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: args
        )
    end
  end
end
