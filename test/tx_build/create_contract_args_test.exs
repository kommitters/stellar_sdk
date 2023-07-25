defmodule Stellar.TxBuild.CreateContractArgsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    Asset,
    CreateContractArgs,
    ContractIDPreimage,
    ContractExecutable
  }

  alias StellarBase.XDR.CreateContractArgs, as: CreateContractArgsXDR

  setup do
    asset = Asset.new(:native)
    contract_executable = ContractExecutable.new(:token)
    contract_id_preimage = ContractIDPreimage.new(from_asset: asset)

    %{
      asset: asset,
      contract_id_preimage: contract_id_preimage,
      contract_executable: contract_executable
    }
  end

  test "new/1", %{
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable
  } do
    %CreateContractArgs{
      contract_id_preimage: ^contract_id_preimage,
      contract_executable: ^contract_executable
    } =
      CreateContractArgs.new(
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable
      )
  end

  test "new/1 with invalid ContractIDPreimage", %{contract_executable: contract_executable} do
    {:error, :invalid_contract_id_preimage} =
      CreateContractArgs.new(
        contract_id_preimage: "invalid",
        contract_executable: contract_executable
      )
  end

  test "new/1 with invalid ContractExecutable", %{contract_id_preimage: contract_id_preimage} do
    {:error, :invalid_contract_executable} =
      CreateContractArgs.new(
        contract_executable: "invalid",
        contract_id_preimage: contract_id_preimage
      )
  end

  test "to_xdr/1", %{
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable
  } do
    %CreateContractArgsXDR{
      contract_id_preimage: %StellarBase.XDR.ContractIDPreimage{
        value: %StellarBase.XDR.Asset{
          asset: %StellarBase.XDR.Void{value: nil},
          type: %StellarBase.XDR.AssetType{identifier: :ASSET_TYPE_NATIVE}
        },
        type: %StellarBase.XDR.ContractIDPreimageType{
          identifier: :CONTRACT_ID_PREIMAGE_FROM_ASSET
        }
      },
      executable: %StellarBase.XDR.ContractExecutable{
        value: %StellarBase.XDR.Void{value: nil},
        type: %StellarBase.XDR.ContractExecutableType{identifier: :CONTRACT_EXECUTABLE_TOKEN}
      }
    } =
      CreateContractArgs.new(
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable
      )
      |> CreateContractArgs.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_struct} = CreateContractArgs.to_xdr("invalid_struct")
  end
end
