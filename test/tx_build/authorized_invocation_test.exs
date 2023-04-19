defmodule Stellar.TxBuild.AuthorizedInvocationTest do
  use ExUnit.Case

  alias Stellar.TxBuild.AuthorizedInvocation, as: TxAuthorizedInvocation
  alias Stellar.TxBuild.SCVal, as: TxSCVal

  alias StellarBase.XDR.{
    AuthorizedInvocation,
    AuthorizedInvocationList,
    Hash,
    Int32,
    SCSymbol,
    SCVal,
    SCValType,
    SCVec
  }

  setup do
    contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
    function_name = "function_name"

    sc_val = TxSCVal.new(i32: 123)
    args = [sc_val]

    authorized_invocation = TxAuthorizedInvocation.new([contract_id, function_name, args, []])

    %{
      contract_id: contract_id,
      function_name: function_name,
      args: args,
      sub_invocations: [authorized_invocation]
    }
  end

  test "new/1 without sub_invocations", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args
  } do
    %TxAuthorizedInvocation{
      contract_id: ^contract_id,
      function_name: ^function_name,
      args: ^args,
      sub_invocations: []
    } =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: []
      )
  end

  test "new/1 with sub_invocations", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args
  } do
    %TxAuthorizedInvocation{} =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: []
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_authorized_invocation} = TxAuthorizedInvocation.new("invalid_args")
  end

  test "new/1 with invalid sub_invocations value", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args
  } do
    {:error, :invalid_sub_invocations} =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: "invalid_value"
      )
  end

  test "new/1 with invalid sub_invocations list", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args
  } do
    {:error, :invalid_sub_invocations} =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: [1, 2, 3, 4]
      )
  end

  test "to_xdr/1", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args
  } do
    %AuthorizedInvocation{
      contract_id: %Hash{
        value:
          <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75, 68, 84,
            157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
      },
      function_name: %SCSymbol{value: "function_name"},
      args: %SCVec{
        sc_vals: [
          %SCVal{
            value: %Int32{datum: 123},
            type: %SCValType{identifier: :SCV_I32}
          }
        ]
      },
      sub_invocations: %AuthorizedInvocationList{sub_invocations: []}
    } =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: []
      )
      |> TxAuthorizedInvocation.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_authorized_invocation} =
      TxAuthorizedInvocation.to_xdr("invalid_struct")
  end
end
