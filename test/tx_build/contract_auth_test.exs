defmodule Stellar.TxBuild.ContractAuthTest do
  use ExUnit.Case

  alias Stellar.TxBuild.ContractAuth, as: TxContractAuth
  alias Stellar.TxBuild.AddressWithNonce, as: TxAddressWithNonce
  alias Stellar.TxBuild.AuthorizedInvocation, as: TxAuthorizedInvocation
  alias Stellar.TxBuild.SCVal, as: TxSCVal
  alias Stellar.TxBuild.SCAddress, as: TxSCAddress

  alias StellarBase.XDR.{
    AddressWithNonce,
    AuthorizedInvocation,
    AuthorizedInvocationList,
    ContractAuth,
    Hash,
    Int32,
    OptionalAddressWithNonce,
    SCAddress,
    SCAddressType,
    SCVec,
    SCVal,
    SCValType,
    SCSymbol,
    UInt64
  }

  setup do
    # ADDRESS WITH NONCE
    sc_address = TxSCAddress.new(contract: "contract_id")
    address_with_nonce = TxAddressWithNonce.new([sc_address, 123])

    # AUTHORIZED INVOCATION
    contract_id = "contract_id"
    function_name = "function_name"
    args = [TxSCVal.new(i32: 321)]
    authorized_invocation_1 = TxAuthorizedInvocation.new([contract_id, function_name, args, []])

    authorized_invocation_2 =
      TxAuthorizedInvocation.new([contract_id, function_name, args, [authorized_invocation_1]])

    # SCVAL
    signature_args = [TxSCVal.new(i32: 456)]

    %{
      address_with_nonce: address_with_nonce,
      authorized_invocation: authorized_invocation_2,
      signature_args: signature_args
    }
  end

  test "new/1", %{
    address_with_nonce: address_with_nonce,
    authorized_invocation: authorized_invocation_2,
    signature_args: signature_args
  } do
    %TxContractAuth{
      address_with_nonce: ^address_with_nonce,
      authorized_invocation: ^authorized_invocation_2,
      signature_args: ^signature_args
    } = TxContractAuth.new([address_with_nonce, authorized_invocation_2, signature_args])
  end

  test "new/1 when invalid contract auth parameters" do
    {:error, :invalid_contract_auth} = TxContractAuth.new([123])
  end

  test "to_xdr/1", %{
    address_with_nonce: address_with_nonce,
    authorized_invocation: authorized_invocation_2,
    signature_args: signature_args
  } do
    %ContractAuth{
      address_with_nonce: %OptionalAddressWithNonce{
        address_with_nonce: %AddressWithNonce{
          address: %SCAddress{
            sc_address: %Hash{value: "contract_id"},
            type: %SCAddressType{identifier: :SC_ADDRESS_contract}
          },
          nonce: %UInt64{datum: 123}
        }
      },
      authorized_invocation: %AuthorizedInvocation{
        args: %SCVec{
          sc_vals: [
            %SCVal{
              type: %SCValType{identifier: :SCV_I32},
              value: %Int32{datum: 321}
            }
          ]
        },
        contract_id: %Hash{value: "contract_id"},
        function_name: %SCSymbol{value: "function_name"},
        sub_invocations: %AuthorizedInvocationList{
          sub_invocations: [
            %AuthorizedInvocation{
              args: %SCVec{
                sc_vals: [
                  %SCVal{
                    type: %SCValType{identifier: :SCV_I32},
                    value: %Int32{datum: 321}
                  }
                ]
              },
              contract_id: %Hash{value: "contract_id"},
              function_name: %SCSymbol{value: "function_name"},
              sub_invocations: %AuthorizedInvocationList{
                sub_invocations: []
              }
            }
          ]
        }
      },
      signature_args: %SCVec{
        sc_vals: [
          %SCVal{
            type: %SCValType{identifier: :SCV_I32},
            value: %Int32{datum: 456}
          }
        ]
      }
    } =
      [address_with_nonce, authorized_invocation_2, signature_args]
      |> TxContractAuth.new()
      |> TxContractAuth.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_contract_auth} = TxContractAuth.to_xdr("invalid_struct")
  end
end
