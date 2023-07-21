defmodule Stellar.TxBuild.ContractIDPreimageFromAddressTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{SCAddress, ContractIDPreimageFromAddress}
  alias StellarBase.XDR.ContractIDPreimageFromAddress, as: ContractIDPreimageFromAddressXDR

  setup do
    salt =
      <<142, 226, 180, 159, 151, 224, 223, 135, 33, 210, 154, 238, 13, 199, 60, 77, 67, 167, 216,
        125, 245, 241, 237, 114, 207, 74, 226, 98, 166, 200, 43, 89>>

    address = SCAddress.new("GDZ6PM5NEFJTCKPGKXV5KCJ7RYQNPWYUB2RCBIXDYULPX2B7UW54IVN7")

    %{
      salt: salt,
      address: address
    }
  end

  test "new/1", %{salt: salt, address: address} do
    %ContractIDPreimageFromAddress{
      address: ^address,
      salt: ^salt
    } = ContractIDPreimageFromAddress.new([{:address, address}, {:salt, salt}])
  end

  test "new/1 with invalid values" do
    {:error, :invalid_contract_id_preimage_value} =
      ContractIDPreimageFromAddress.new([{:address, "invalid"}, {:salt, 1234}])
  end

  test "to_xdr/1", %{salt: salt, address: address} do
    %ContractIDPreimageFromAddressXDR{
      address: %StellarBase.XDR.SCAddress{
        sc_address: %StellarBase.XDR.AccountID{
          account_id: %StellarBase.XDR.PublicKey{
            public_key: %StellarBase.XDR.UInt256{
              datum:
                <<243, 231, 179, 173, 33, 83, 49, 41, 230, 85, 235, 213, 9, 63, 142, 32, 215, 219,
                  20, 14, 162, 32, 162, 227, 197, 22, 251, 232, 63, 165, 187, 196>>
            },
            type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        },
        type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
      },
      salt: %StellarBase.XDR.UInt256{
        datum:
          <<142, 226, 180, 159, 151, 224, 223, 135, 33, 210, 154, 238, 13, 199, 60, 77, 67, 167,
            216, 125, 245, 241, 237, 114, 207, 74, 226, 98, 166, 200, 43, 89>>
      }
    } =
      ContractIDPreimageFromAddress.new([{:address, address}, {:salt, salt}])
      |> ContractIDPreimageFromAddress.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_struct} = ContractIDPreimageFromAddress.to_xdr("invalid_struct")
  end
end
