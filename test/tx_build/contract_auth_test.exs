defmodule Stellar.TxBuild.ContractAuthTest do
  use ExUnit.Case

  alias Stellar.TxBuild.ContractAuth, as: TxContractAuth
  alias Stellar.TxBuild.AddressWithNonce, as: TxAddressWithNonce
  alias Stellar.TxBuild.OptionalAddressWithNonce, as: TxOptionalAddressWithNonce
  alias Stellar.TxBuild.AuthorizedInvocation, as: TxAuthorizedInvocation
  alias Stellar.TxBuild.SCVal, as: TxSCVal
  alias Stellar.TxBuild.SCAddress, as: TxSCAddress

  alias StellarBase.XDR.{
    AccountID,
    AddressWithNonce,
    AuthorizedInvocation,
    AuthorizedInvocationList,
    ContractAuth,
    Hash,
    Int32,
    OptionalAddressWithNonce,
    OptionalSCVec,
    PublicKey,
    PublicKeyType,
    SCAddress,
    SCAddressType,
    SCVec,
    SCVal,
    SCValType,
    SCSymbol,
    UInt64,
    UInt256
  }

  setup do
    # ADDRESS WITH NONCE
    sc_address = TxSCAddress.new("GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")

    address_with_nonce = TxAddressWithNonce.new(address: sc_address, nonce: 123)
    optional_address_with_nonce = TxOptionalAddressWithNonce.new(address_with_nonce)

    # AUTHORIZED INVOCATION
    contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
    function_name = "hello"
    args = [TxSCVal.new(i32: 321)]

    authorized_invocation_1 =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        sub_invocations: [],
        args: args
      )

    authorized_invocation_2 =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        sub_invocations: [authorized_invocation_1],
        args: args
      )

    # SCVAL
    signature_args = [TxSCVal.new(i32: 456)]

    secret_key = "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK"

    base_64_without_sign =
      "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAAAAAABL5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAABHN3YXAAAAACAAAACgAAAAAAAABkAAAAAAAAAAAAAAAKAAAAAAAAE4gAAAAAAAAAAAAAAAAAAAAA"

    base_64_string =
      "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAAAAAABL5BOLMcxdDZ2RtTGT10MW0lRAZ5TsD4HT7UD03BuGpuAAAABHN3YXAAAAACAAAACgAAAAAAAABkAAAAAAAAAAAAAAAKAAAAAAAAE4gAAAAAAAAAAAAAAAAAAAABAAAAEAAAAAEAAAABAAAAEQAAAAEAAAACAAAADwAAAApwdWJsaWNfa2V5AAAAAAANAAAAIMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAADwAAAAlzaWduYXR1cmUAAAAAAAANAAAAQJUdF06WSRhT4dI1W4OhVEyjN3lOCTIFcLDmF+F1d4tc+g1e9sRmjDuz14tj+wXE3VeJxgn+94B92A6fZmeZEgI="

    %{
      address_with_nonce: address_with_nonce,
      authorized_invocation: authorized_invocation_2,
      signature_args: signature_args,
      optional_address_with_nonce: optional_address_with_nonce,
      secret_key: secret_key,
      base_64_string: base_64_string,
      base_64_without_sign: base_64_without_sign
    }
  end

  test "new/1", %{
    address_with_nonce: address_with_nonce,
    optional_address_with_nonce: optional_address_with_nonce,
    authorized_invocation: authorized_invocation_2,
    signature_args: signature_args
  } do
    %TxContractAuth{
      address_with_nonce: ^optional_address_with_nonce,
      authorized_invocation: ^authorized_invocation_2,
      signature_args: ^signature_args
    } =
      TxContractAuth.new(
        address_with_nonce: address_with_nonce,
        authorized_invocation: authorized_invocation_2,
        signature_args: signature_args
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_contract_auth} = TxContractAuth.new("invalid_args")
  end

  test "new/1 with invalid authorized_invocation", %{
    address_with_nonce: address_with_nonce,
    signature_args: signature_args
  } do
    {:error, :invalid_authorized_invocation} =
      TxContractAuth.new(
        address_with_nonce: address_with_nonce,
        authorized_invocation: "invalid",
        signature_args: signature_args
      )
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
            sc_address: %AccountID{
              account_id: %PublicKey{
                public_key: %UInt256{
                  datum:
                    <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87,
                      6, 25, 27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
                },
                type: %PublicKeyType{
                  identifier: :PUBLIC_KEY_TYPE_ED25519
                }
              }
            },
            type: %SCAddressType{
              identifier: :SC_ADDRESS_TYPE_ACCOUNT
            }
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
        contract_id: %Hash{
          value:
            <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75, 68, 84,
              157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
        },
        function_name: %SCSymbol{value: "hello"},
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
              contract_id: %Hash{
                value:
                  <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75, 68,
                    84, 157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
              },
              function_name: %SCSymbol{value: "hello"},
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
            type: %SCValType{identifier: :SCV_VEC},
            value: %OptionalSCVec{
              sc_vec: %SCVec{
                sc_vals: [
                  %SCVal{
                    type: %SCValType{identifier: :SCV_I32},
                    value: %Int32{datum: 456}
                  }
                ]
              }
            }
          }
        ]
      }
    } =
      [
        address_with_nonce: address_with_nonce,
        authorized_invocation: authorized_invocation_2,
        signature_args: signature_args
      ]
      |> TxContractAuth.new()
      |> TxContractAuth.to_xdr()
  end

  test "sign/2", %{
    address_with_nonce: address_with_nonce,
    authorized_invocation: authorized_invocation_2,
    signature_args: signature_args
  } do
    contract_auth =
      TxContractAuth.new(
        address_with_nonce: address_with_nonce,
        authorized_invocation: authorized_invocation_2,
        signature_args: signature_args
      )

    %Stellar.TxBuild.ContractAuth{
      address_with_nonce: %Stellar.TxBuild.OptionalAddressWithNonce{
        address_with_nonce: %Stellar.TxBuild.AddressWithNonce{
          address: %Stellar.TxBuild.SCAddress{
            type: :account,
            value: "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
          },
          nonce: 123
        }
      },
      authorized_invocation: %Stellar.TxBuild.AuthorizedInvocation{
        contract_id: "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c",
        function_name: "hello",
        args: [%Stellar.TxBuild.SCVal{type: :i32, value: 321}],
        sub_invocations: [
          %Stellar.TxBuild.AuthorizedInvocation{
            contract_id: "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c",
            function_name: "hello",
            args: [%Stellar.TxBuild.SCVal{type: :i32, value: 321}],
            sub_invocations: []
          }
        ]
      },
      signature_args: [
        %Stellar.TxBuild.SCVal{type: :i32, value: 456},
        %Stellar.TxBuild.SCVal{
          type: :map,
          value: [
            %Stellar.TxBuild.SCMapEntry{
              key: %Stellar.TxBuild.SCVal{type: :symbol, value: "public_key"},
              val: %Stellar.TxBuild.SCVal{
                type: :bytes,
                value:
                  <<90, 59, 33, 159, 27, 241, 148, 234, 43, 78, 208, 73, 92, 40, 119, 5, 169, 84,
                    190, 125, 179, 121, 108, 107, 112, 211, 32, 194, 193, 98, 177, 218>>
              }
            },
            %Stellar.TxBuild.SCMapEntry{
              key: %Stellar.TxBuild.SCVal{type: :symbol, value: "signature"},
              val: %Stellar.TxBuild.SCVal{
                type: :bytes,
                value:
                  <<70, 0, 69, 48, 162, 145, 42, 247, 159, 79, 173, 195, 194, 115, 212, 186, 218,
                    171, 113, 111, 0, 136, 135, 161, 252, 135, 105, 217, 69, 85, 196, 95, 223,
                    168, 95, 103, 122, 132, 220, 26, 84, 216, 10, 6, 123, 204, 218, 216, 102, 166,
                    159, 111, 129, 17, 233, 40, 245, 237, 184, 223, 158, 0, 41, 10>>
              }
            }
          ]
        }
      ]
    } =
      TxContractAuth.sign(
        contract_auth,
        "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24"
      )
  end

  test "sign/2 with invalid secret key", %{
    address_with_nonce: address_with_nonce,
    authorized_invocation: authorized_invocation_2,
    signature_args: signature_args
  } do
    contract_auth =
      TxContractAuth.new(
        address_with_nonce: address_with_nonce,
        authorized_invocation: authorized_invocation_2,
        signature_args: signature_args
      )

    {:error, :invalid_secret_key} = TxContractAuth.sign(contract_auth, 123)
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_contract_auth} = TxContractAuth.to_xdr("invalid_struct")
  end

  test "sign_xdr/2", %{
    base_64_without_sign: base_64_without_sign,
    base_64_string: base_64_string,
    secret_key: secret_key
  } do
    ^base_64_string = TxContractAuth.sign_xdr(base_64_without_sign, secret_key)
  end
end
