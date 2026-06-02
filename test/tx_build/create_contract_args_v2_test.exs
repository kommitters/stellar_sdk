defmodule Stellar.TxBuild.CreateContractArgsV2Test do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    Asset,
    CreateContractArgsV2,
    ContractIDPreimage,
    ContractExecutable,
    SCVal
  }

  alias StellarBase.XDR.CreateContractArgsV2, as: CreateContractArgsV2XDR

  setup do
    asset = Asset.new(:native)
    contract_executable = ContractExecutable.new(:stellar_asset)
    contract_id_preimage = ContractIDPreimage.new(from_asset: asset)
    constructor_args = [SCVal.new(i32: 123)]

    %{
      asset: asset,
      contract_id_preimage: contract_id_preimage,
      contract_executable: contract_executable,
      constructor_args: constructor_args
    }
  end

  test "new/1", %{
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable,
    constructor_args: constructor_args
  } do
    %CreateContractArgsV2{
      contract_id_preimage: ^contract_id_preimage,
      contract_executable: ^contract_executable,
      constructor_args: ^constructor_args
    } =
      CreateContractArgsV2.new(
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable,
        constructor_args: constructor_args
      )
  end

  test "new/1 with invalid ContractIDPreimage", %{
    contract_executable: contract_executable,
    constructor_args: constructor_args
  } do
    {:error, :invalid_contract_id_preimage} =
      CreateContractArgsV2.new(
        contract_id_preimage: "invalid",
        contract_executable: contract_executable,
        constructor_args: constructor_args
      )
  end

  test "new/1 with invalid ContractExecutable", %{
    contract_id_preimage: contract_id_preimage,
    constructor_args: constructor_args
  } do
    {:error, :invalid_contract_executable} =
      CreateContractArgsV2.new(
        contract_executable: "invalid",
        contract_id_preimage: contract_id_preimage,
        constructor_args: constructor_args
      )
  end

  test "new/1 with invalid ConstructorArgs", %{
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable
  } do
    {:error, :invalid_constructor_args} =
      CreateContractArgsV2.new(
        contract_executable: contract_executable,
        contract_id_preimage: contract_id_preimage,
        constructor_args: "invalid"
      )

    {:error, :invalid_constructor_args} =
      CreateContractArgsV2.new(
        contract_executable: contract_executable,
        contract_id_preimage: contract_id_preimage,
        constructor_args: [123]
      )
  end

  test "to_xdr/1", %{
    contract_id_preimage: contract_id_preimage,
    contract_executable: contract_executable,
    constructor_args: constructor_args
  } do
    %CreateContractArgsV2XDR{
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
        type: %StellarBase.XDR.ContractExecutableType{
          identifier: :CONTRACT_EXECUTABLE_STELLAR_ASSET
        }
      },
      constructor_args: %StellarBase.XDR.SCValList{
        items: [
          %StellarBase.XDR.SCVal{
            type: %StellarBase.XDR.SCValType{identifier: :SCV_I32},
            value: %StellarBase.XDR.Int32{datum: 123}
          }
        ]
      }
    } =
      CreateContractArgsV2.new(
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable,
        constructor_args: constructor_args
      )
      |> CreateContractArgsV2.to_xdr()
  end

  test "to_xdr/1 with the struct is invalid" do
    {:error, :invalid_struct} = CreateContractArgsV2.to_xdr("invalid_struct")
  end
end
