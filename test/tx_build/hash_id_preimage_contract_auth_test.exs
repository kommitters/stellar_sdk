defmodule Stellar.TxBuild.HashIDPreimageContractAuthTest do
  use ExUnit.Case

  alias Stellar.TxBuild.HashIDPreimageContractAuth, as: TxHashIDPreimageContractAuth
  alias Stellar.TxBuild.AuthorizedInvocation, as: TxAuthorizedInvocation
  alias Stellar.TxBuild.SCVal, as: TxSCVal

  alias StellarBase.XDR.{
    AuthorizedInvocation,
    AuthorizedInvocationList,
    HashIDPreimageContractAuth,
    Hash,
    Int32,
    SCSymbol,
    SCVal,
    SCVec,
    SCValType,
    UInt64
  }

  setup do
    # SCVAL
    sc_val = TxSCVal.new(i32: 123)

    # AUTHORIZED INVOCATION
    contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
    function_name = "function_name"
    args = [sc_val]

    authorized_invocation_1 =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: []
      )

    authorized_invocation_2 =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: [authorized_invocation_1]
      )

    %{
      network_id: "network_id",
      nonce: 123,
      invocation: authorized_invocation_2
    }
  end

  test "new/1", %{network_id: network_id, nonce: nonce, invocation: invocation} do
    %TxHashIDPreimageContractAuth{
      network_id: ^network_id,
      nonce: ^nonce,
      invocation: ^invocation
    } =
      TxHashIDPreimageContractAuth.new(
        network_id: network_id,
        nonce: nonce,
        invocation: invocation
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_hash_id_preimage_contract_auth} =
      TxHashIDPreimageContractAuth.new("invalid_args")
  end

  test "new/1 with invalid authorized invocation", %{network_id: network_id, nonce: nonce} do
    {:error, :invalid_invocation} =
      TxHashIDPreimageContractAuth.new(
        network_id: network_id,
        nonce: nonce,
        invocation: "invalid_value"
      )
  end

  test "to_xdr/1", %{
    network_id: network_id,
    nonce: nonce,
    invocation: invocation
  } do
    %HashIDPreimageContractAuth{
      network_id: %Hash{value: "network_id"},
      nonce: %UInt64{datum: 123},
      invocation: %AuthorizedInvocation{
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
        sub_invocations: %AuthorizedInvocationList{
          sub_invocations: [
            %AuthorizedInvocation{
              contract_id: %Hash{
                value:
                  <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75, 68,
                    84, 157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
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
            }
          ]
        }
      }
    } =
      TxHashIDPreimageContractAuth.new(
        network_id: network_id,
        nonce: nonce,
        invocation: invocation
      )
      |> TxHashIDPreimageContractAuth.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_hash_id_preimage_contract_auth} =
      TxHashIDPreimageContractAuth.to_xdr("invalid_struct")
  end
end
