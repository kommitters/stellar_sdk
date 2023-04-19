defmodule Stellar.TxBuild.OptionalAddressWithNonceTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{OptionalAddressWithNonce, AddressWithNonce, SCAddress}

  setup do
    address = SCAddress.new(account: "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")
    nonce = 123
    address_with_nonce = AddressWithNonce.new(address: address, nonce: nonce)
    optional_address_with_nonce = OptionalAddressWithNonce.new(address_with_nonce)

    %{
      address_with_nonce: address_with_nonce,
      optional_address_with_nonce: optional_address_with_nonce
    }
  end

  test "new/1", %{
    address_with_nonce: address_with_nonce
  } do
    %OptionalAddressWithNonce{address_with_nonce: ^address_with_nonce} =
      OptionalAddressWithNonce.new(address_with_nonce)
  end

  test "new/2 with_nil_value" do
    %OptionalAddressWithNonce{address_with_nonce: nil} = OptionalAddressWithNonce.new(nil)
  end

  test "new/2 with invalid address with nonce" do
    {:error, :invalid_optional_address_with_nonce} = OptionalAddressWithNonce.new("invalid_value")
  end

  test "to_xdr/1", %{
    address_with_nonce: address_with_nonce
  } do
    %StellarBase.XDR.OptionalAddressWithNonce{
      address_with_nonce: %StellarBase.XDR.AddressWithNonce{
        address: %StellarBase.XDR.SCAddress{
          sc_address: %StellarBase.XDR.AccountID{
            account_id: %StellarBase.XDR.PublicKey{
              public_key: %StellarBase.XDR.UInt256{
                datum:
                  <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87, 6,
                    25, 27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
              },
              type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
            }
          },
          type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
        },
        nonce: %StellarBase.XDR.UInt64{datum: 123}
      }
    } =
      address_with_nonce
      |> OptionalAddressWithNonce.new()
      |> OptionalAddressWithNonce.to_xdr()
  end

  test "to_xdr/1 with_nil_value" do
    %StellarBase.XDR.OptionalAddressWithNonce{address_with_nonce: nil} =
      nil
      |> OptionalAddressWithNonce.new()
      |> OptionalAddressWithNonce.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_optional_address_with_nonce} =
      OptionalAddressWithNonce.to_xdr("invalid_struct")
  end
end
