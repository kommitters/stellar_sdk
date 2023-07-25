defmodule Stellar.TxBuild.HashIDPreimageContractIDTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    Asset,
    HashIDPreimageContractID,
    ContractIDPreimage
  }

  setup do
    network_id = "network"
    asset = Asset.new(:native)
    contract_id_preimage = ContractIDPreimage.new(from_asset: asset)

    %{
      network_id: network_id,
      contract_id_preimage: contract_id_preimage
    }
  end

  test "new/1", %{
    contract_id_preimage: contract_id_preimage,
    network_id: network_id
  } do
    %HashIDPreimageContractID{
      contract_id_preimage: ^contract_id_preimage,
      network_id: ^network_id
    } =
      HashIDPreimageContractID.new(
        network_id: network_id,
        contract_id_preimage: contract_id_preimage
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_hash_id_preimage_contract_id} =
      HashIDPreimageContractID.new(
        network_id: 1234,
        contract_id_preimage: "invalid"
      )
  end

  test "new/1 with invalid ContractIDPreimage", %{
    network_id: network_id
  } do
    {:error, :invalid_contract_id_preimage} =
      HashIDPreimageContractID.new(
        network_id: network_id,
        contract_id_preimage: "invalid"
      )
  end

  test "to_xdr/1", %{
    contract_id_preimage: contract_id_preimage,
    network_id: network_id
  } do
    %StellarBase.XDR.HashIDPreimageContractID{
      network_id: %StellarBase.XDR.Hash{value: "network"},
      contract_id_preimage: %StellarBase.XDR.ContractIDPreimage{
        value: %StellarBase.XDR.Asset{
          asset: %StellarBase.XDR.Void{value: nil},
          type: %StellarBase.XDR.AssetType{identifier: :ASSET_TYPE_NATIVE}
        },
        type: %StellarBase.XDR.ContractIDPreimageType{
          identifier: :CONTRACT_ID_PREIMAGE_FROM_ASSET
        }
      }
    } =
      HashIDPreimageContractID.new(
        network_id: network_id,
        contract_id_preimage: contract_id_preimage
      )
      |> HashIDPreimageContractID.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_struct} = HashIDPreimageContractID.to_xdr("invalid_struct")
  end
end
