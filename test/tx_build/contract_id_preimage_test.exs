defmodule Stellar.TxBuild.ContractIDPreimageTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Asset, SCAddress, ContractIDPreimage, ContractIDPreimageFromAddress}
  alias StellarBase.XDR.ContractIDPreimage, as: ContractIDPreimageXDR

  setup do
    salt =
      <<142, 226, 180, 159, 151, 224, 223, 135, 33, 210, 154, 238, 13, 199, 60, 77, 67, 167, 216,
        125, 245, 241, 237, 114, 207, 74, 226, 98, 166, 200, 43, 89>>

    address = SCAddress.new("GDZ6PM5NEFJTCKPGKXV5KCJ7RYQNPWYUB2RCBIXDYULPX2B7UW54IVN7")

    contract_id_preimage_from_address =
      ContractIDPreimageFromAddress.new([{:address, address}, {:salt, salt}])

    asset = Asset.new(:native)

    %{
      asset: asset,
      contract_id_preimage_from_address: contract_id_preimage_from_address
    }
  end

  test "new/1 when type is from_address", %{
    contract_id_preimage_from_address: contract_id_preimage_from_address
  } do
    %ContractIDPreimage{
      type: :from_address,
      value: ^contract_id_preimage_from_address
    } = ContractIDPreimage.new(from_address: contract_id_preimage_from_address)
  end

  test "new/1 when type is from_asset", %{asset: asset} do
    %ContractIDPreimage{
      type: :from_asset,
      value: ^asset
    } = ContractIDPreimage.new(from_asset: asset)
  end

  test "new/1 with invalid type", %{asset: asset} do
    {:error, :invalid_contract_id_preimage} = ContractIDPreimage.new(any: asset)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_contract_id_preimage} = ContractIDPreimage.new("invalid_args")
  end

  test "new/1 with invalid ContractIDPreimageFromAddress" do
    {:error, :invalid_from_address} = ContractIDPreimage.new(from_address: "invalid")
  end

  test "new/1 with invalid Asset" do
    {:error, :invalid_from_asset} = ContractIDPreimage.new(from_asset: "invalid")
  end

  test "to_xdr/1 with from_address type", %{
    contract_id_preimage_from_address: contract_id_preimage_from_address
  } do
    %ContractIDPreimageXDR{
      value: %StellarBase.XDR.ContractIDPreimageFromAddress{
        address: %StellarBase.XDR.SCAddress{
          sc_address: %StellarBase.XDR.AccountID{
            account_id: %StellarBase.XDR.PublicKey{
              public_key: %StellarBase.XDR.UInt256{
                datum:
                  <<243, 231, 179, 173, 33, 83, 49, 41, 230, 85, 235, 213, 9, 63, 142, 32, 215,
                    219, 20, 14, 162, 32, 162, 227, 197, 22, 251, 232, 63, 165, 187, 196>>
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
      },
      type: %StellarBase.XDR.ContractIDPreimageType{
        identifier: :CONTRACT_ID_PREIMAGE_FROM_ADDRESS
      }
    } =
      ContractIDPreimage.new(from_address: contract_id_preimage_from_address)
      |> ContractIDPreimage.to_xdr()
  end

  test "to_xdr/1 with asset type", %{asset: asset} do
    %ContractIDPreimageXDR{
      value: %StellarBase.XDR.Asset{
        asset: %StellarBase.XDR.Void{value: nil},
        type: %StellarBase.XDR.AssetType{identifier: :ASSET_TYPE_NATIVE}
      },
      type: %StellarBase.XDR.ContractIDPreimageType{identifier: :CONTRACT_ID_PREIMAGE_FROM_ASSET}
    } =
      ContractIDPreimage.new(from_asset: asset)
      |> ContractIDPreimage.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_struct} = ContractIDPreimage.to_xdr("invalid_struct")
  end
end
