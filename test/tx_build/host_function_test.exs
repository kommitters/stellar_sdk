defmodule Stellar.TxBuild.HostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{HostFunction, SCVal}

  import Stellar.Test.XDRFixtures, only: [host_function_xdr: 4, host_function_install_xdr: 2]

  describe "HostFunction invoke" do
    setup do
      type = :invoke
      install_type = :install
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]

      code =
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 19, 4, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          1, 127, 0, 96, 0, 0, 2, 37, 6, 1, 118, 1, 95, 0, 0, 1, 118, 1, 54, 0, 1, 1, 97, 1, 48,
          0, 0, 1, 108, 1, 48, 0, 0>>

      %{
        type: type,
        install_type: install_type,
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        xdr: host_function_xdr(type, contract_id, function_name, args),
        install_xdr: host_function_install_xdr(install_type, code),
        code: code
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

    test "new/2 with_invalid_type", %{
      contract_id: contract_id,
      function_name: function_name,
      args: args
    } do
      {:error, :invalid_operation_attributes} =
        HostFunction.new(
          type: :invalid,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )
    end

    test "new/2 with_invalid_contract_id", %{
      type: type,
      function_name: function_name,
      args: args
    } do
      {:error, :invalid_contract_id} =
        HostFunction.new(
          type: type,
          contract_id: "hello-not-hex-encoded-string",
          function_name: function_name,
          args: args
        )
    end

    test "new/2 with_invalid_function_name", %{
      type: type,
      contract_id: contract_id,
      args: args
    } do
      {:error, :invalid_function_name} =
        HostFunction.new(
          type: type,
          contract_id: contract_id,
          function_name: 123,
          args: args
        )
    end

    test "new/2 with_invalid_args", %{
      type: type,
      contract_id: contract_id,
      function_name: function_name
    } do
      {:error, :invalid_args} =
        HostFunction.new(
          type: type,
          contract_id: contract_id,
          function_name: function_name,
          args: [1, 2, 3]
        )
    end

    test "new/2 when type is :install", %{install_type: type, code: code} do
      %HostFunction{type: ^type, code: ^code} =
        HostFunction.new(
          type: type,
          code: code
        )
    end

    test "new/2 when type is :install with invalid code", %{install_type: type} do
      {:error, :invalid_operation_attributes} =
        HostFunction.new(
          type: type,
          code: 1234
        )
    end

    test "to_xdr/1", %{
      type: type,
      contract_id: contract_id,
      function_name: function_name,
      args: args,
      xdr: xdr
    } do
      ^xdr =
        [type: type, contract_id: contract_id, function_name: function_name, args: args]
        |> HostFunction.new()
        |> HostFunction.to_xdr()
    end

    test "to_xdr/1 install", %{
      install_type: install_type,
      code: code,
      install_xdr: install_xdr
    } do
      ^install_xdr =
        [type: install_type, code: code]
        |> HostFunction.new()
        |> HostFunction.to_xdr()
    end
  end
end
