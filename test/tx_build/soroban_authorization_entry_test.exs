defmodule Stellar.TxBuild.SorobanAuthorizationEntryTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SorobanAuthorizedInvocation
  alias Stellar.TxBuild.SorobanAuthorizedFunction
  alias Stellar.TxBuild.SorobanCredentials
  alias Stellar.TxBuild.SorobanAuthorizedContractFunction
  alias Stellar.TxBuild.SCVal
  alias Stellar.TxBuild.SCVec
  alias Stellar.TxBuild.SCAddress
  alias Stellar.TxBuild.SorobanAuthorizationEntry

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
        sub_invocations: %StellarBase.XDR.SorobanAuthorizedInvocationList{items: []}
      }
    }

    %{
      credentials: credentials,
      root_invocation: root_invocation,
      soroban_auth_entry: soroban_auth_entry,
      xdr: xdr
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

  test "to_xdr/1", %{soroban_auth_entry: soroban_auth_entry, xdr: xdr} do
    ^xdr = SorobanAuthorizationEntry.to_xdr(soroban_auth_entry)
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SorobanAuthorizationEntry.to_xdr(:invalid)
  end
end
