defmodule Stellar.TxBuild.HostFunctionTest do
  use ExUnit.Case

  alias StellarBase.XDR.HostFunction, as: HostFunctionXDR

  alias Stellar.TxBuild.{
    AddressWithNonce,
    AuthorizedInvocation,
    ContractAuth,
    HostFunction,
    HostFunctionArgs,
    SCAddress,
    SCVal
  }

  import Stellar.Test.XDRFixtures,
    only: [
      host_function_xdr: 4,
      host_function_with_auth_xdr: 4
    ]

  describe "HostFunction invoke" do
    setup do
      contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      function_name = "hello"
      args = [SCVal.new(symbol: "world")]
      sc_address = SCAddress.new("GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN")
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

      contract_auth_strs = [
        "AAAAAQAAAAAAAAAAI1vLirSR6kLZXoAEB0ofGAubX8OJ5BPcmfMZAkCsd5cAAAAAAAAAewRhFoy7rg2pbFQ7cf1XGuxLRFSdUD+a+edoXM7bwWE8AAAABWhlbGxvAAAAAAAAAQAAAA8AAAAFd29ybGQAAAAAAAABBGEWjLuuDalsVDtx/Vca7EtEVJ1QP5r552hcztvBYTwAAAAFaGVsbG8AAAAAAAABAAAADwAAAAV3b3JsZAAAAAAAAAAAAAABAAAAEAAAAAEAAAAA"
      ]

      function_args =
        HostFunctionArgs.new(
          type: :invoke,
          contract_id: contract_id,
          function_name: function_name,
          args: args
        )

      %{
        function_args: function_args,
        contract_authentication: contract_authentication,
        contract_auth_strs: contract_auth_strs,
        host_function: HostFunction.new(args: function_args),
        host_function_with_auth:
          HostFunction.new(args: function_args, auth: [contract_authentication]),
        host_function_xdr: host_function_xdr(:invoke, contract_id, function_name, args),
        host_function_with_auth_xdr:
          host_function_with_auth_xdr(:invoke, contract_id, function_name, args)
      }
    end

    test "new/2", %{
      function_args: function_args
    } do
      %HostFunction{
        args: ^function_args
      } = HostFunction.new(args: function_args)
    end

    test "new/2 with auth", %{
      function_args: function_args,
      contract_authentication: contract_authentication
    } do
      %HostFunction{
        args: ^function_args
      } = HostFunction.new(args: function_args, auth: [contract_authentication])
    end

    test "new/2 invalid attributes" do
      {:error, :invalid_operation_attributes} = HostFunction.new(:invalid)
    end

    test "new/2 invalid args" do
      {:error, :invalid_args} = HostFunction.new(args: :invalid)
    end

    test "new/2 invalid auth", %{function_args: function_args} do
      {:error, :invalid_auth} = HostFunction.new(args: function_args, auth: [123])
    end

    test "set_auth/2", %{
      function_args: function_args,
      host_function: host_function,
      contract_auth_strs: contract_auth_strs
    } do
      %HostFunction{
        args: ^function_args,
        auth: ^contract_auth_strs
      } = HostFunction.set_auth(host_function, contract_auth_strs)
    end

    test "set_auth/2 nil auth str", %{
      function_args: function_args,
      host_function: host_function
    } do
      %HostFunction{
        args: ^function_args,
        auth: [nil]
      } = HostFunction.set_auth(host_function, [nil])
    end

    test "set_auth/2 invalid xdr string", %{host_function: host_function} do
      {:error, :invalid_auth} = HostFunction.set_auth(host_function, ["invalid"])
    end

    test "to_xdr/1", %{
      host_function_xdr: host_function_xdr,
      host_function: host_function
    } do
      %HostFunctionXDR{args: ^host_function_xdr} = HostFunction.to_xdr(host_function)
    end

    test "to_xdr/1 with auth", %{
      host_function_with_auth_xdr: host_function_with_auth_xdr,
      host_function_with_auth: host_function_with_auth
    } do
      # %HostFunctionXDR{args: ^host_function_xdr}
      ^host_function_with_auth_xdr = HostFunction.to_xdr(host_function_with_auth)
    end

    test "to_xdr/1 with auth strs", %{
      host_function_with_auth_xdr: host_function_with_auth_xdr,
      host_function: host_function,
      contract_auth_strs: contract_auth_strs
    } do
      ^host_function_with_auth_xdr =
        host_function
        |> HostFunction.set_auth(contract_auth_strs)
        |> HostFunction.to_xdr()
    end
  end
end
