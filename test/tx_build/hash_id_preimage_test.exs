defmodule Stellar.TxBuild.HashIDPreimageTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCAddress, as: TxSCAddress
  alias Stellar.TxBuild.SorobanAuthorizedContractFunction, as: TxSorobanAuthorizedContractFunction
  alias Stellar.TxBuild.SorobanAuthorizedFunction, as: TxSorobanAuthorizedFunction
  alias Stellar.TxBuild.SorobanAuthorizedInvocation, as: TxSorobanAuthorizedInvocation

  alias Stellar.TxBuild.HashIDPreimageSorobanAuthorization,
    as: TxHashIDPreimageSorobanAuthorization

  alias Stellar.TxBuild.ContractIDPreimage, as: TxContactIDPreimage
  alias Stellar.TxBuild.Asset, as: TxAsset
  alias Stellar.TxBuild.HashIDPreimage, as: TxHashIDPreimage
  alias Stellar.TxBuild.SequenceNumber, as: TxSequenceNumber
  alias Stellar.TxBuild.SCVal, as: TxSCVal
  alias Stellar.TxBuild.SCVec, as: TxSCVec
  alias Stellar.TxBuild.HashIDPreimageOperationID, as: TxOperationID
  alias Stellar.TxBuild.HashIDPreimageRevokeID, as: TxRevokeID
  alias Stellar.TxBuild.HashIDPreimageContractID, as: TxHashIDPreimageContractID

  alias StellarBase.XDR.{
    AccountID,
    Asset,
    AssetType,
    ContractIDPreimage,
    ContractIDPreimageType,
    EnvelopeType,
    Hash,
    HashIDPreimage,
    HashIDPreimageContractID,
    Int32,
    HashIDPreimageOperationID,
    PublicKey,
    PublicKeyType,
    PoolID,
    HashIDPreimageRevokeID,
    SorobanAuthorizedContractFunction,
    SorobanAuthorizedFunction,
    SorobanAuthorizedFunctionType,
    SorobanAuthorizedInvocation,
    SorobanAuthorizedInvocationList,
    HashIDPreimageSorobanAuthorization,
    SequenceNumber,
    SCAddress,
    SCAddressType,
    SCVal,
    SCValType,
    SCVec,
    SCSymbol,
    UInt256,
    UInt32,
    Int64,
    Void
  }

  setup do
    public_key = "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"

    # HashIDPreimageOperationID
    sequence_number = TxSequenceNumber.new(123_456_789)
    op_num = 123

    # HashIDPreimageRevokeID
    pool_id_value = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    asset = :native

    # HashIDPreimageContractID
    network_id = "network_id"
    contract_id_preimage = TxContactIDPreimage.new(from_asset: TxAsset.new(:native))

    # SorobanAuthorizedInvocation
    contract_address = TxSCAddress.new("CACGCFUMXOXA3KLMKQ5XD7KXDLWEWRCUTVID7GXZ45UFZTW3YFQTZD6Y")
    function_name = "function_name"
    args = TxSCVec.new([TxSCVal.new(i32: 654)])

    contract_function =
      TxSorobanAuthorizedContractFunction.new(
        contract_address: contract_address,
        function_name: function_name,
        args: args
      )

    function = TxSorobanAuthorizedFunction.new(contract_fn: contract_function)

    invocation = TxSorobanAuthorizedInvocation.new(function: function, sub_invocations: [])

    %{
      operation_id:
        TxOperationID.new(
          source_account: public_key,
          sequence_number: sequence_number,
          op_num: op_num
        ),
      revoke_id:
        TxRevokeID.new(
          source_account: public_key,
          sequence_number: sequence_number,
          op_num: op_num,
          liquidity_pool_id: pool_id_value,
          asset: asset
        ),
      contract_id:
        TxHashIDPreimageContractID.new(
          network_id: network_id,
          contract_id_preimage: contract_id_preimage
        ),
      soroban_auth:
        TxHashIDPreimageSorobanAuthorization.new(
          network_id: network_id,
          nonce: 123_185,
          signature_expiration_ledger: 123_541,
          invocation: invocation
        )
    }
  end

  test "new/1 when type is op_id", %{operation_id: operation_id} do
    %TxHashIDPreimage{type: :op_id, value: ^operation_id} =
      TxHashIDPreimage.new(op_id: operation_id)
  end

  test "new/1 when op_id value is wrong" do
    {:error, :invalid_op_id} = TxHashIDPreimage.new(op_id: :wrong_value)
  end

  test "new/1 when type is pool_revoke_op_id", %{revoke_id: revoke_id} do
    %TxHashIDPreimage{type: :pool_revoke_op_id, value: ^revoke_id} =
      TxHashIDPreimage.new(pool_revoke_op_id: revoke_id)
  end

  test "new/1 when pool_revoke_op_id value is wrong" do
    {:error, :invalid_pool_revoke_op_id} = TxHashIDPreimage.new(pool_revoke_op_id: :wrong_value)
  end

  test "new/1 when type is contract_id", %{contract_id: contract_id} do
    %TxHashIDPreimage{type: :contract_id, value: ^contract_id} =
      TxHashIDPreimage.new(contract_id: contract_id)
  end

  test "new/1 when contract_id value is wrong" do
    {:error, :invalid_contract_id} = TxHashIDPreimage.new(contract_id: :wrong_value)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_hash_id_preimage_type} = TxHashIDPreimage.new("invalid_args")
  end

  test "to_xdr/1 when type is op_id", %{operation_id: operation_id} do
    %HashIDPreimage{
      value: %HashIDPreimageOperationID{
        op_num: %UInt32{datum: 123},
        seq_num: %SequenceNumber{sequence_number: 123_456_789},
        source_account: %AccountID{
          account_id: %PublicKey{
            public_key: %UInt256{
              datum:
                <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87, 6,
                  25, 27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
            },
            type: %PublicKeyType{
              identifier: :PUBLIC_KEY_TYPE_ED25519
            }
          }
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_OP_ID}
    } = TxHashIDPreimage.new(op_id: operation_id) |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is pool_revoke_op_id", %{revoke_id: revoke_id} do
    %HashIDPreimage{
      value: %HashIDPreimageRevokeID{
        source_account: %AccountID{
          account_id: %PublicKey{
            public_key: %UInt256{
              datum:
                <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87, 6,
                  25, 27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
            },
            type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        },
        seq_num: %SequenceNumber{sequence_number: 123_456_789},
        op_num: %UInt32{datum: 123},
        liquidity_pool_id: %PoolID{
          value:
            <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
              141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
        },
        asset: %Asset{
          asset: %Void{value: nil},
          type: %AssetType{identifier: :ASSET_TYPE_NATIVE}
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_POOL_REVOKE_OP_ID}
    } =
      TxHashIDPreimage.new(pool_revoke_op_id: revoke_id)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is contract_id", %{contract_id: contract_id} do
    %HashIDPreimage{
      value: %HashIDPreimageContractID{
        network_id: %Hash{value: "network_id"},
        contract_id_preimage: %ContractIDPreimage{
          value: %Asset{
            asset: %Void{value: nil},
            type: %AssetType{identifier: :ASSET_TYPE_NATIVE}
          },
          type: %ContractIDPreimageType{
            identifier: :CONTRACT_ID_PREIMAGE_FROM_ASSET
          }
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_CONTRACT_ID}
    } =
      TxHashIDPreimage.new(contract_id: contract_id)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is soroban_auth", %{soroban_auth: soroban_auth} do
    %HashIDPreimage{
      value: %HashIDPreimageSorobanAuthorization{
        network_id: %Hash{value: "network_id"},
        nonce: %Int64{datum: 123_185},
        signature_expiration_ledger: %UInt32{datum: 123_541},
        invocation: %SorobanAuthorizedInvocation{
          function: %SorobanAuthorizedFunction{
            value: %SorobanAuthorizedContractFunction{
              contract_address: %SCAddress{
                sc_address: %Hash{
                  value:
                    <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75,
                      68, 84, 157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
                },
                type: %SCAddressType{
                  identifier: :SC_ADDRESS_TYPE_CONTRACT
                }
              },
              function_name: %SCSymbol{value: "function_name"},
              args: %SCVec{
                items: [
                  %SCVal{
                    value: %Int32{datum: 654},
                    type: %SCValType{identifier: :SCV_I32}
                  }
                ]
              }
            },
            type: %SorobanAuthorizedFunctionType{
              identifier: :SOROBAN_AUTHORIZED_FUNCTION_TYPE_CONTRACT_FN
            }
          },
          sub_invocations: %SorobanAuthorizedInvocationList{
            items: []
          }
        }
      },
      type: %EnvelopeType{
        identifier: :ENVELOPE_TYPE_SOROBAN_AUTHORIZATION
      }
    } =
      TxHashIDPreimage.new(soroban_auth: soroban_auth)
      |> TxHashIDPreimage.to_xdr()
  end
end
