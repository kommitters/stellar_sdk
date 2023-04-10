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
    contract_id = "contract_id"
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
    } = TxAuthorizedInvocation.new([contract_id, function_name, args, []])
  end

  test "new/1 with sub_invocations", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args,
    sub_invocations: sub_invocations
  } do
    %TxAuthorizedInvocation{} =
      TxAuthorizedInvocation.new([contract_id, function_name, args, sub_invocations])
  end

  test "new/1 with invalid args" do
    {:error, :invalid_authorized_invocation} = TxAuthorizedInvocation.new("invalid_args")
  end

  test "to_xdr/1", %{
    contract_id: contract_id,
    function_name: function_name,
    args: args,
    sub_invocations: sub_invocations
  } do
    %AuthorizedInvocation{
      contract_id: %Hash{value: ^contract_id},
      function_name: %SCSymbol{value: ^function_name},
      args: %SCVec{
        sc_vals: [
          %SCVal{
            value: %Int32{datum: 123},
            type: %SCValType{identifier: :SCV_I32}
          }
        ]
      },
      sub_invocations: %AuthorizedInvocationList{
        sub_invocations: [
          %AuthorizedInvocation{
            contract_id: %Hash{value: ^contract_id},
            function_name: %SCSymbol{value: ^function_name},
            args: %SCVec{
              sc_vals: [
                %SCVal{
                  value: %Int32{datum: 123},
                  type: %SCValType{identifier: :SCV_I32}
                }
              ]
            },
            sub_invocations: %AuthorizedInvocationList{
              sub_invocations: []
            }
          }
        ]
      }
    } =
      TxAuthorizedInvocation.new([contract_id, function_name, args, sub_invocations])
      |> TxAuthorizedInvocation.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_authorized_invocation} =
      TxAuthorizedInvocation.to_xdr("invalid_struct")
  end
end
