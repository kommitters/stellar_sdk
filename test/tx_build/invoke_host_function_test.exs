defmodule Stellar.TxBuild.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    HostFunction,
    InvokeHostFunction,
    SCAddress,
    SCVal,
    InvokeContractArgs,
    SorobanAuthorizedFunction,
    SorobanAuthorizedInvocation,
    SorobanCredentials,
    SorobanAuthorizationEntry
  }

  import Stellar.Test.XDRFixtures,
    only: [invoke_host_function_op_xdr: 1, invoke_host_function_op_xdr: 2]

  describe "InvokeHostFunction" do
    setup do
      sc_contract_address =
        SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")

      function_name = "hello"
      fn_args = [SCVal.new(symbol: "dev")]

      contract_fn =
        InvokeContractArgs.new(
          contract_address: sc_contract_address,
          function_name: function_name,
          args: fn_args
        )

      host_function = HostFunction.new(invoke_contract: contract_fn)

      invoke_host_function_op = InvokeHostFunction.new(host_function: host_function, auths: [])

      soroban_function = SorobanAuthorizedFunction.new(contract_fn: contract_fn)

      root_invocation =
        SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [])

      credentials = SorobanCredentials.new(source_account: nil)

      auths = [
        SorobanAuthorizationEntry.new(credentials: credentials, root_invocation: root_invocation)
      ]

      base_64_auths = [
        "AAAAAAAAAAAAAAABZ+A/h5d/0pJnw7wmIzptCvWoX0md87QkHN68pAOfYjgAAAADaW5jAAAAAAIAAAASAAAAAAAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAAkAAAAAAAAAAAAAAAAAAAACAAAAAA=="
      ]

      %{
        host_function: host_function,
        invoke_host_function_op: invoke_host_function_op,
        auths: auths,
        base_64_auths: base_64_auths,
        xdr: invoke_host_function_op_xdr(host_function),
        xdr_with_auth: invoke_host_function_op_xdr(host_function, auths)
      }
    end

    test "new/2 without auths", %{host_function: host_function} do
      %InvokeHostFunction{
        host_function: ^host_function
      } = InvokeHostFunction.new(host_function: host_function)
    end

    test "new/2 with auths", %{host_function: host_function, auths: auths} do
      %InvokeHostFunction{
        host_function: ^host_function,
        auths: ^auths
      } = InvokeHostFunction.new(host_function: host_function, auths: auths)
    end

    test "new/2 with base 64 auths", %{host_function: host_function, base_64_auths: base_64_auths} do
      %InvokeHostFunction{
        host_function: ^host_function,
        auths: ^base_64_auths
      } =
        InvokeHostFunction.new(host_function: host_function)
        |> InvokeHostFunction.set_auth(base_64_auths)
    end

    test "new/2 invalid host_function" do
      {:error, :invalid_host_host_function} =
        InvokeHostFunction.new(host_function: :invalid, auths: [])
    end

    test "new/2 invalid auths", %{host_function: host_function} do
      {:error, :invalid_soroban_auth_entries} =
        InvokeHostFunction.new(host_function: host_function, auths: [:invalid])
    end

    test "new/2 invalid auths list", %{host_function: host_function} do
      {:error, :invalid_soroban_auth_entries} =
        InvokeHostFunction.new(host_function: host_function, auths: :invalid)
    end

    test "new/2 with invalid base 64 auths", %{
      host_function: host_function
    } do
      {:error, :invalid_auth} =
        InvokeHostFunction.new(host_function: host_function)
        |> InvokeHostFunction.set_auth(["invalid"])
    end

    test "new/2 with invalid list of base 64 auths", %{
      host_function: host_function
    } do
      {:error, :invalid_auth} =
        InvokeHostFunction.new(host_function: host_function)
        |> InvokeHostFunction.set_auth(:invalid)
    end

    test "new/2 with invalid attributes" do
      {:error, :invalid_operation_attributes} = InvokeHostFunction.new(:invalid)
    end

    test "to_xdr/1", %{
      invoke_host_function_op: invoke_host_function_op,
      xdr: xdr
    } do
      ^xdr = InvokeHostFunction.to_xdr(invoke_host_function_op)
    end

    test "to_xdr/2 with auth entry list", %{
      host_function: host_function,
      auths: auths,
      xdr_with_auth: xdr_with_auth
    } do
      ^xdr_with_auth =
        [host_function: host_function, auths: auths]
        |> InvokeHostFunction.new()
        |> InvokeHostFunction.to_xdr()
    end
  end
end
