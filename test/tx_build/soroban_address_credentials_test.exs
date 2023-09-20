defmodule Stellar.TxBuild.SorobanAddressCredentialsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCAddress,
    SCVal,
    SorobanAddressCredentials
  }

  setup do
    address = SCAddress.new("GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3")
    signature = SCVal.new(symbol: "dev")
    nonce = 544_841
    signature_expiration_ledger = 106_977

    xdr = %StellarBase.XDR.SorobanAddressCredentials{
      address: %StellarBase.XDR.SCAddress{
        sc_address: %StellarBase.XDR.AccountID{
          account_id: %StellarBase.XDR.PublicKey{
            public_key: %StellarBase.XDR.UInt256{
              datum:
                <<90, 59, 33, 159, 27, 241, 148, 234, 43, 78, 208, 73, 92, 40, 119, 5, 169, 84,
                  190, 125, 179, 121, 108, 107, 112, 211, 32, 194, 193, 98, 177, 218>>
            },
            type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        },
        type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
      },
      nonce: %StellarBase.XDR.Int64{datum: 544_841},
      signature_expiration_ledger: %StellarBase.XDR.UInt32{datum: 106_977},
      signature: %StellarBase.XDR.SCVal{
        value: %StellarBase.XDR.SCSymbol{value: "dev"},
        type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
      }
    }

    %{
      address: address,
      signature: signature,
      nonce: nonce,
      signature_expiration_ledger: signature_expiration_ledger,
      soroban_address_credentials:
        SorobanAddressCredentials.new(
          address: address,
          signature: signature,
          nonce: nonce,
          signature_expiration_ledger: signature_expiration_ledger
        ),
      xdr: xdr
    }
  end

  test "new/2", %{
    address: address,
    signature: signature,
    nonce: nonce,
    signature_expiration_ledger: signature_expiration_ledger
  } do
    %SorobanAddressCredentials{
      address: ^address,
      signature: ^signature,
      nonce: ^nonce,
      signature_expiration_ledger: ^signature_expiration_ledger
    } =
      SorobanAddressCredentials.new(
        address: address,
        signature: signature,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger
      )
  end

  test "new/2 with invalid address", %{
    signature: signature,
    nonce: nonce,
    signature_expiration_ledger: signature_expiration_ledger
  } do
    {:error, :invalid_address} =
      SorobanAddressCredentials.new(
        address: :invalid,
        signature: signature,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger
      )
  end

  test "new/2 with invalid signature", %{
    address: address,
    nonce: nonce,
    signature_expiration_ledger: signature_expiration_ledger
  } do
    {:error, :invalid_sc_val} =
      SorobanAddressCredentials.new(
        address: address,
        signature: :invalid,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger
      )
  end

  test "new/2 with invalid nonce", %{
    address: address,
    signature: signature,
    signature_expiration_ledger: signature_expiration_ledger
  } do
    {:error, :invalid_nonce} =
      SorobanAddressCredentials.new(
        address: address,
        signature: signature,
        nonce: :invalid,
        signature_expiration_ledger: signature_expiration_ledger
      )
  end

  test "new/2 with invalid signature_expiration_ledger", %{
    address: address,
    signature: signature,
    nonce: nonce
  } do
    {:error, :invalid_signature_expiration_ledger} =
      SorobanAddressCredentials.new(
        address: address,
        signature: signature,
        nonce: nonce,
        signature_expiration_ledger: :invalid
      )
  end

  test "new/2 with invalid args" do
    {:error, :invalid_soroban_address_args} = SorobanAddressCredentials.new(:invalid)
  end

  test "to_xdr/1", %{soroban_address_credentials: soroban_address_credentials, xdr: xdr} do
    ^xdr = SorobanAddressCredentials.to_xdr(soroban_address_credentials)
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = SorobanAddressCredentials.to_xdr(:invalid)
  end
end
