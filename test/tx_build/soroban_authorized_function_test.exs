defmodule Stellar.TxBuild.SorobanAuthorizedFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCVec,
    SCVal,
    CreateContractArgs,
    ContractIDPreimage,
    ContractIDPreimageFromAddress,
    SCAddress,
    ContractExecutable,
    SorobanAuthorizedContractFunction,
    SorobanAuthorizedFunction
  }

  setup do
    fn_args = SCVec.new([SCVal.new(symbol: "dev")])

    contract_address = SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")

    function_name = "hello"

    contract_fn =
      SorobanAuthorizedContractFunction.new(
        contract_address: contract_address,
        function_name: function_name,
        args: fn_args
      )

    wasm_id =
      <<86, 32, 6, 9, 172, 4, 212, 185, 249, 87, 184, 164, 58, 34, 167, 183, 226, 117, 205, 116,
        11, 130, 119, 172, 224, 51, 12, 148, 90, 251, 17, 12>>

    contract_executable = ContractExecutable.new(wasm_ref: wasm_id)
    sc_address = SCAddress.new("GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN")
    # :crypto.strong_rand_bytes(32)
    salt =
      <<142, 226, 180, 159, 151, 224, 223, 135, 33, 210, 154, 238, 13, 199, 60, 77, 67, 167, 216,
        125, 245, 241, 237, 114, 207, 74, 226, 98, 166, 200, 43, 89>>

    from_address = ContractIDPreimageFromAddress.new(address: sc_address, salt: salt)
    contract_id_preimage = ContractIDPreimage.new(from_address: from_address)

    create_contract_args =
      CreateContractArgs.new(
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable
      )

    discriminants = [
      %{type: :contract_fn, value: contract_fn},
      %{type: :create_contract_host_fn, value: create_contract_args}
    ]

    invalid_discriminants = [
      %{type: :contract_fn, value: :invalid},
      %{type: :create_contract_host_fn, value: :invalid}
    ]

    xdr_discriminants = [
      %{
        xdr: %StellarBase.XDR.SorobanAuthorizedFunction{
          value: %StellarBase.XDR.SorobanAuthorizedContractFunction{
            contract_address: %StellarBase.XDR.SCAddress{
              sc_address: %StellarBase.XDR.Hash{
                value:
                  <<103, 224, 63, 135, 151, 127, 210, 146, 103, 195, 188, 38, 35, 58, 109, 10,
                    245, 168, 95, 73, 157, 243, 180, 36, 28, 222, 188, 164, 3, 159, 98, 56>>
              },
              type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_CONTRACT}
            },
            function_name: %StellarBase.XDR.SCSymbol{value: "hello"},
            args: %StellarBase.XDR.SCVec{
              items: [
                %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.SCSymbol{value: "dev"},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
                }
              ]
            }
          },
          type: %StellarBase.XDR.SorobanAuthorizedFunctionType{
            identifier: :SOROBAN_AUTHORIZED_FUNCTION_TYPE_CONTRACT_FN
          }
        },
        type: :contract_fn,
        value: contract_fn
      },
      %{
        xdr: %StellarBase.XDR.SorobanAuthorizedFunction{
          value: %StellarBase.XDR.CreateContractArgs{
            contract_id_preimage: %StellarBase.XDR.ContractIDPreimage{
              value: %StellarBase.XDR.ContractIDPreimageFromAddress{
                address: %StellarBase.XDR.SCAddress{
                  sc_address: %StellarBase.XDR.AccountID{
                    account_id: %StellarBase.XDR.PublicKey{
                      public_key: %StellarBase.XDR.UInt256{
                        datum:
                          <<35, 91, 203, 138, 180, 145, 234, 66, 217, 94, 128, 4, 7, 74, 31, 24,
                            11, 155, 95, 195, 137, 228, 19, 220, 153, 243, 25, 2, 64, 172, 119,
                            151>>
                      },
                      type: %StellarBase.XDR.PublicKeyType{
                        identifier: :PUBLIC_KEY_TYPE_ED25519
                      }
                    }
                  },
                  type: %StellarBase.XDR.SCAddressType{
                    identifier: :SC_ADDRESS_TYPE_ACCOUNT
                  }
                },
                salt: %StellarBase.XDR.UInt256{
                  datum:
                    <<142, 226, 180, 159, 151, 224, 223, 135, 33, 210, 154, 238, 13, 199, 60, 77,
                      67, 167, 216, 125, 245, 241, 237, 114, 207, 74, 226, 98, 166, 200, 43, 89>>
                }
              },
              type: %StellarBase.XDR.ContractIDPreimageType{
                identifier: :CONTRACT_ID_PREIMAGE_FROM_ADDRESS
              }
            },
            executable: %StellarBase.XDR.ContractExecutable{
              value: %StellarBase.XDR.Hash{
                value:
                  <<86, 32, 6, 9, 172, 4, 212, 185, 249, 87, 184, 164, 58, 34, 167, 183, 226, 117,
                    205, 116, 11, 130, 119, 172, 224, 51, 12, 148, 90, 251, 17, 12>>
              },
              type: %StellarBase.XDR.ContractExecutableType{
                identifier: :CONTRACT_EXECUTABLE_WASM
              }
            }
          },
          type: %StellarBase.XDR.SorobanAuthorizedFunctionType{
            identifier: :SOROBAN_AUTHORIZED_FUNCTION_TYPE_CREATE_CONTRACT_HOST_FN
          }
        },
        type: :create_contract_host_fn,
        value: create_contract_args
      }
    ]

    %{
      discriminants: discriminants,
      invalid_discriminants: invalid_discriminants,
      xdr_discriminants: xdr_discriminants
    }
  end

  test "new/1", %{discriminants: discriminants} do
    for %{type: type, value: value} <- discriminants do
      %SorobanAuthorizedFunction{
        type: ^type,
        value: ^value
      } = SorobanAuthorizedFunction.new([{type, value}])
    end
  end

  test "new/1 with invalid values", %{invalid_discriminants: invalid_discriminants} do
    for %{type: type, value: value} <- invalid_discriminants do
      error = :"invalid_#{type}"
      {:error, ^error} = SorobanAuthorizedFunction.new([{type, value}])
    end
  end

  test "new/1 with invalid args" do
    {:error, :invalid_soroban_auth_function} = SorobanAuthorizedFunction.new(:invalid)
  end

  test "to_xdr/1", %{xdr_discriminants: xdr_discriminants} do
    for %{xdr: xdr, type: type, value: value} <- xdr_discriminants do
      ^xdr =
        SorobanAuthorizedFunction.new([{type, value}])
        |> SorobanAuthorizedFunction.to_xdr()
    end
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SorobanAuthorizedFunction.to_xdr(%{})
  end
end
