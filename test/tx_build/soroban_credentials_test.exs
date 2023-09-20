defmodule Stellar.TxBuild.SorobanCredentialsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCVal,
    SorobanCredentials,
    SCAddress,
    SorobanAddressCredentials
  }

  setup do
    address = SCAddress.new("GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3")
    signature = SCVal.new(symbol: "dev")

    soroban_address_credentials =
      SorobanAddressCredentials.new(
        address: address,
        nonce: 123_135,
        signature_expiration_ledger: 123_515,
        signature: signature
      )

    discriminants = [
      %{type: :source_account, value: nil},
      %{type: :address, value: soroban_address_credentials}
    ]

    invalid_discriminants = [
      %{type: :source_account, value: :invalid},
      %{type: :address, value: :invalid}
    ]

    xdr_discriminants = [
      %{
        xdr: %StellarBase.XDR.SorobanCredentials{
          value: %StellarBase.XDR.Void{value: nil},
          type: %StellarBase.XDR.SorobanCredentialsType{
            identifier: :SOROBAN_CREDENTIALS_SOURCE_ACCOUNT
          }
        },
        type: :source_account,
        value: nil
      },
      %{
        xdr: %StellarBase.XDR.SorobanCredentials{
          value: %StellarBase.XDR.SorobanAddressCredentials{
            address: %StellarBase.XDR.SCAddress{
              sc_address: %StellarBase.XDR.AccountID{
                account_id: %StellarBase.XDR.PublicKey{
                  public_key: %StellarBase.XDR.UInt256{
                    datum:
                      <<90, 59, 33, 159, 27, 241, 148, 234, 43, 78, 208, 73, 92, 40, 119, 5, 169,
                        84, 190, 125, 179, 121, 108, 107, 112, 211, 32, 194, 193, 98, 177, 218>>
                  },
                  type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
                }
              },
              type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
            },
            nonce: %StellarBase.XDR.Int64{datum: 123_135},
            signature_expiration_ledger: %StellarBase.XDR.UInt32{datum: 123_515},
            signature: %StellarBase.XDR.SCVal{
              value: %StellarBase.XDR.SCSymbol{value: "dev"},
              type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
            }
          },
          type: %StellarBase.XDR.SorobanCredentialsType{identifier: :SOROBAN_CREDENTIALS_ADDRESS}
        },
        type: :address,
        value: soroban_address_credentials
      }
    ]

    %{
      soroban_address_credentials: soroban_address_credentials,
      discriminants: discriminants,
      invalid_discriminants: invalid_discriminants,
      xdr_discriminants: xdr_discriminants
    }
  end

  test "new/2", %{discriminants: discriminants} do
    for %{type: type, value: value} <- discriminants do
      %SorobanCredentials{
        type: ^type,
        value: ^value
      } = SorobanCredentials.new([{type, value}])
    end
  end

  test "new/2 with invalid values", %{invalid_discriminants: invalid_discriminants} do
    for %{type: type, value: value} <- invalid_discriminants do
      error = :"invalid_#{type}"
      {:error, ^error} = SorobanCredentials.new([{type, value}])
    end
  end

  test "new/2 with invalid args" do
    {:error, :invalid_soroban_credential} = SorobanCredentials.new(:invalid)
  end

  test "to_xdr/1", %{xdr_discriminants: xdr_discriminants} do
    for %{xdr: xdr, type: type, value: value} <- xdr_discriminants do
      ^xdr = SorobanCredentials.new([{type, value}]) |> SorobanCredentials.to_xdr()
    end
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SorobanCredentials.to_xdr(%{})
  end
end
