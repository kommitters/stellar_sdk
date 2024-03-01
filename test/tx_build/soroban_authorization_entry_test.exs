defmodule Stellar.TxBuild.SorobanAuthorizationEntryTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCAddress,
    SCMapEntry,
    SCVal,
    SorobanAddressCredentials,
    SorobanAuthorizedInvocation,
    SorobanAuthorizedFunction,
    InvokeContractArgs,
    SorobanAuthorizationEntry,
    SorobanCredentials
  }

  alias Stellar.Network

  setup do
    fn_args = [SCVal.new(symbol: "dev")]

    contract_address = SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")

    function_name = "hello"

    contract_fn =
      InvokeContractArgs.new(
        contract_address: contract_address,
        function_name: function_name,
        args: fn_args
      )

    soroban_function = SorobanAuthorizedFunction.new(contract_fn: contract_fn)

    root_invocation =
      SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [])

    credentials = SorobanCredentials.new(source_account: nil)

    soroban_auth_entry =
      SorobanAuthorizationEntry.new(credentials: credentials, root_invocation: root_invocation)

    xdr = %StellarBase.XDR.SorobanAuthorizationEntry{
      credentials: %StellarBase.XDR.SorobanCredentials{
        value: %StellarBase.XDR.Void{value: nil},
        type: %StellarBase.XDR.SorobanCredentialsType{
          identifier: :SOROBAN_CREDENTIALS_SOURCE_ACCOUNT
        }
      },
      root_invocation: %StellarBase.XDR.SorobanAuthorizedInvocation{
        function: %StellarBase.XDR.SorobanAuthorizedFunction{
          value: %StellarBase.XDR.InvokeContractArgs{
            contract_address: %StellarBase.XDR.SCAddress{
              sc_address: %StellarBase.XDR.Hash{
                value:
                  <<103, 224, 63, 135, 151, 127, 210, 146, 103, 195, 188, 38, 35, 58, 109, 10,
                    245, 168, 95, 73, 157, 243, 180, 36, 28, 222, 188, 164, 3, 159, 98, 56>>
              },
              type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_CONTRACT}
            },
            function_name: %StellarBase.XDR.SCSymbol{value: "hello"},
            args: %StellarBase.XDR.SCValList{
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
        sub_invocations: %StellarBase.XDR.SorobanAuthorizedInvocationList{items: []}
      }
    }

    address = SCAddress.new("GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM")
    nonce = 1_078_069_780
    signature_expiration_ledger = 164_080

    soroban_address_credentials =
      SorobanAddressCredentials.new(
        address: address,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        signature: SCVal.new(vec: [])
      )

    address_credentials = SorobanCredentials.new(address: soroban_address_credentials)

    soroban_auth_entry_with_address_credentials =
      SorobanAuthorizationEntry.new(
        credentials: address_credentials,
        root_invocation: root_invocation
      )

    %{
      credentials: credentials,
      root_invocation: root_invocation,
      soroban_auth_entry: soroban_auth_entry,
      xdr: xdr,
      base_64:
        "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYOvJBkmBOF7wAAAAAAAAABAAAAAAAAAAEJjPko7iuhBRtsY0aDQ2Einilpmj/rDyGds/qx5seSNAAAAANpbmMAAAAAAgAAABIAAAAAAAAAAMlOeOVhwnFIoNq3vyNsTIORWqja6Gk1fgF0G2oavH7WAAAACQAAAAAAAAAAAAAAAAAAAAIAAAAA",
      secret_key: "SCAVFA3PI3MJLTQNMXOUNBSEUOSY66YMG3T2KCQKLQBENNVLVKNPV3EK",
      latest_ledger: 164_256,
      network_passphrase: Network.testnet_passphrase(),
      sign_xdr:
        "AAAAAQAAAAAAAAAAyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYOvJBkmBOF7wACgaMAAAAQAAAAAQAAAAEAAAARAAAAAQAAAAIAAAAPAAAACnB1YmxpY19rZXkAAAAAAA0AAAAgyU545WHCcUig2re/I2xMg5FaqNroaTV+AXQbahq8ftYAAAAPAAAACXNpZ25hdHVyZQAAAAAAAA0AAABAIVZ/t4FbgBOE7+B6u41RkQhUrePyoyxrNwGh8oN2HtGtmyuxBwlU49nBUgUwBHmHiQMIMBEW7IbyPNGSuK4YCAAAAAAAAAABCYz5KO4roQUbbGNGg0NhIp4paZo/6w8hnbP6sebHkjQAAAADaW5jAAAAAAIAAAASAAAAAAAAAADJTnjlYcJxSKDat78jbEyDkVqo2uhpNX4BdBtqGrx+1gAAAAkAAAAAAAAAAAAAAAAAAAACAAAAAA==",
      soroban_auth_entry_with_address_credentials: soroban_auth_entry_with_address_credentials,
      address_credentials: address_credentials
    }
  end

  test "new/2", %{credentials: credentials, root_invocation: root_invocation} do
    %SorobanAuthorizationEntry{
      credentials: ^credentials,
      root_invocation: ^root_invocation
    } = SorobanAuthorizationEntry.new(credentials: credentials, root_invocation: root_invocation)
  end

  test "new/2 with invalid credentials", %{root_invocation: root_invocation} do
    {:error, :invalid_credentials} =
      SorobanAuthorizationEntry.new(credentials: :invalid, root_invocation: root_invocation)
  end

  test "new/2 with invalid root_invocation", %{credentials: credentials} do
    {:error, :invalid_root_invocation} =
      SorobanAuthorizationEntry.new(credentials: credentials, root_invocation: :invalid)
  end

  test "new/2 with invalid args" do
    {:error, :invalid_auth_entry_args} = SorobanAuthorizationEntry.new(:invalid)
  end

  test "sign/2", %{
    soroban_auth_entry_with_address_credentials: soroban_auth_entry_with_address_credentials,
    root_invocation: root_invocation,
    secret_key: secret_key,
    network_passphrase: network_passphrase
  } do
    %SorobanAuthorizationEntry{
      credentials: %SorobanAddressCredentials{
        address: %SCAddress{
          type: :account,
          value: "GDEU46HFMHBHCSFA3K336I3MJSBZCWVI3LUGSNL6AF2BW2Q2XR7NNAPM"
        },
        nonce: 1_078_069_780,
        signature_expiration_ledger: 164_080,
        signature: %SCVal{
          type: :vec,
          value: [
            %SCVal{
              type: :map,
              value: [
                %SCMapEntry{
                  key: %SCVal{type: :symbol, value: "public_key"},
                  val: %SCVal{
                    type: :bytes,
                    value:
                      <<201, 78, 120, 229, 97, 194, 113, 72, 160, 218, 183, 191, 35, 108, 76, 131,
                        145, 90, 168, 218, 232, 105, 53, 126, 1, 116, 27, 106, 26, 188, 126, 214>>
                  }
                },
                %SCMapEntry{
                  key: %SCVal{type: :symbol, value: "signature"},
                  val: %SCVal{
                    type: :bytes,
                    value:
                      <<150, 185, 157, 21, 98, 125, 110, 204, 42, 246, 50, 2, 183, 10, 131, 52,
                        104, 227, 126, 242, 21, 38, 240, 255, 85, 41, 141, 68, 84, 109, 83, 40,
                        85, 45, 189, 166, 230, 247, 130, 33, 7, 98, 206, 245, 60, 171, 182, 42,
                        10, 185, 218, 200, 114, 119, 66, 120, 20, 170, 133, 131, 105, 148, 91,
                        14>>
                  }
                }
              ]
            }
          ]
        }
      },
      root_invocation: ^root_invocation
    } =
      SorobanAuthorizationEntry.sign(
        soroban_auth_entry_with_address_credentials,
        secret_key,
        network_passphrase
      )
  end

  test "sign/4 invalid secret_key", %{
    soroban_auth_entry_with_address_credentials: soroban_auth_entry_with_address_credentials,
    network_passphrase: network_passphrase
  } do
    {:error, :invalid_sign_args} =
      SorobanAuthorizationEntry.sign(soroban_auth_entry_with_address_credentials, :secret_key, network_passphrase)
  end

  test "sign_xdr/4", %{
    base_64: base_64,
    secret_key: secret_key,
    latest_ledger: latest_ledger,
    network_passphrase: network_passphrase,
    sign_xdr: sign_xdr
  } do
    ^sign_xdr =
      SorobanAuthorizationEntry.sign_xdr(base_64, secret_key, latest_ledger, network_passphrase)
  end

  test "sign_xdr/4 invalid secret_key", %{base_64: base_64, latest_ledger: latest_ledger, network_passphrase: network_passphrase} do
    {:error, :invalid_sign_args} =
      SorobanAuthorizationEntry.sign_xdr(base_64, :secret_key, latest_ledger, network_passphrase)
  end

  test "to_xdr/1", %{soroban_auth_entry: soroban_auth_entry, xdr: xdr} do
    ^xdr = SorobanAuthorizationEntry.to_xdr(soroban_auth_entry)
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SorobanAuthorizationEntry.to_xdr(:invalid)
  end
end
