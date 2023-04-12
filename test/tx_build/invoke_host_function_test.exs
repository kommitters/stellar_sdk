defmodule Stellar.TxBuild.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    AddressWithNonce,
    AuthorizedInvocation,
    ContractAuth,
    HostFunction,
    InvokeHostFunction,
    SCAddress,
    SCVal
  }

  import Stellar.Test.XDRFixtures,
    only: [
      invoke_host_function_op_xdr: 1,
      invoke_host_function_op_xdr: 2,
      invoke_host_function_op_xdr: 3
    ]

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

      sc_address =
        SCAddress.new(contract: "GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN")

      address_with_nonce = AddressWithNonce.new(address: sc_address, nonce: 123)

      authorized_invocation_1 =
        AuthorizedInvocation.new(
          contract_id: contract_id,
          function_name: function_name,
          args: args,
          sub_invocations: []
        )

      authorized_invocation_2 =
        AuthorizedInvocation.new(
          contract_id: contract_id,
          function_name: function_name,
          args: args,
          sub_invocations: [authorized_invocation_1]
        )

      contract_authentication =
        ContractAuth.new(
          address_with_nonce: address_with_nonce,
          authorized_invocation: authorized_invocation_2,
          args: args
        )

      %{
        function: function,
        footprint: footprint,
        contract_authentication: [contract_authentication],
        xdr: invoke_host_function_op_xdr(function, footprint),
        xdr_with_auth:
          invoke_host_function_op_xdr(function, footprint, [contract_authentication]),
        xdr_without_auth_and_footprint: invoke_host_function_op_xdr(function)
      }
    end

    test "new/2", %{
      function: function
    } do
      %InvokeHostFunction{
        function: ^function
      } = InvokeHostFunction.new(function: function)
    end

    test "new/2 with authorization", %{
      function: function,
      contract_authentication: contract_authentication
    } do
      %InvokeHostFunction{
        function: ^function,
        auth: ^contract_authentication
      } =
        InvokeHostFunction.new(
          function: function,
          auth: contract_authentication
        )
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

    test "new/2 with_footprint and authorization", %{
      function: function,
      footprint: footprint,
      contract_authentication: contract_authentication
    } do
      %InvokeHostFunction{
        function: ^function,
        footprint: ^footprint,
        auth: ^contract_authentication
      } =
        InvokeHostFunction.new(
          function: function,
          footprint: footprint,
          auth: contract_authentication
        )
    end

    test "new/2 with_invalid_function" do
      {:error, :invalid_function} = InvokeHostFunction.new(function: "")
    end

    test "new/2 with_invalid_authorization", %{function: function} do
      {:error, :invalid_auth} = InvokeHostFunction.new(function: function, auth: "")
    end

    test "new/2 with_invalid_footprint", %{function: function} do
      {:error, :invalid_footprint} = InvokeHostFunction.new(function: function, footprint: 11)
    end

    test "new/2 with invalid operation attribute" do
      {:error, :invalid_operation_attributes} =
        InvokeHostFunction.new("invalid_operation_attribute")
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

    test "set_footprint with invalid footprint", %{function: function} do
      {:error, :invalid_footprint} =
        [function: function]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.set_footprint("invalid_footprint")
    end

    test "to_xdr/1", %{function: function, footprint: footprint, xdr: xdr} do
      ^xdr =
        [function: function, footprint: footprint]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.to_xdr()
    end

    test "to_xdr/1 with footprint and authorization", %{
      function: function,
      footprint: footprint,
      contract_authentication: auth,
      xdr_with_auth: xdr
    } do
      ^xdr =
        [function: function, footprint: footprint, auth: auth]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.to_xdr()
    end

    test "to_xdr/1 without footprint and authorization", %{
      function: function,
      xdr_without_auth_and_footprint: xdr
    } do
      ^xdr =
        [function: function]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.to_xdr()
    end
  end
end
