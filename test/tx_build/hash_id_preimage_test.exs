defmodule Stellar.TxBuild.HashIDPreimageTest do
  use ExUnit.Case

  alias Stellar.TxBuild.HashIDPreimage, as: TxHashIDPreimage
  alias Stellar.TxBuild.AuthorizedInvocation, as: TxAuthorizedInvocation
  alias Stellar.TxBuild.Ed25519ContractID, as: TxEd25519ContractID
  alias Stellar.TxBuild.FromAsset, as: TxFromAsset
  alias Stellar.TxBuild.HashIDPreimageContractAuth, as: TxHashIDPreimageContractAuth
  alias Stellar.TxBuild.HashIDPreimageCreateContractArgs, as: TxHashIDPreimageCreateContractArgs
  alias Stellar.TxBuild.SequenceNumber, as: TxSequenceNumber
  alias Stellar.TxBuild.SourceAccountContractID, as: TxSourceAccountContractID
  alias Stellar.TxBuild.StructContractID, as: TxStructContractID
  alias Stellar.TxBuild.SCContractCode, as: TxSCContractCode
  alias Stellar.TxBuild.SCVal, as: TxSCVal
  alias Stellar.TxBuild.OperationID, as: TxOperationID
  alias Stellar.TxBuild.RevokeID, as: TxRevokeID

  alias StellarBase.XDR.{
    AccountID,
    Asset,
    AssetType,
    AuthorizedInvocation,
    AuthorizedInvocationList,
    Ed25519ContractID,
    EnvelopeType,
    FromAsset,
    Hash,
    HashIDPreimage,
    HashIDPreimageContractAuth,
    HashIDPreimageCreateContractArgs,
    Int32,
    OperationID,
    PublicKey,
    PublicKeyType,
    PoolID,
    RevokeID,
    SourceAccountContractID,
    SequenceNumber,
    StructContractID,
    SCContractCode,
    SCContractCodeType,
    SCVal,
    SCValType,
    SCVec,
    SCSymbol,
    UInt256,
    UInt32,
    UInt64,
    Void
  }

  setup do
    public_key = "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"

    # OperationID
    sequence_number = TxSequenceNumber.new(123_456_789)
    op_num = 123

    # RevokeID
    pool_id_value = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    asset = :native

    # Ed25519ContractID
    network_id = "network_id"
    ed25519 = 456
    salt = 456

    # StructContractID
    contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"

    # HashIDPreimageCreateContractArgs
    wasm_ref_sc_contract_code = TxSCContractCode.new(wasm_ref: "wasm_ref")
    token_sc_contract_code = TxSCContractCode.new(token: "")

    # HashIDPreimageContractAuth
    nonce = 987
    function_name = "function_name"
    args = [TxSCVal.new(i32: 654)]

    invocation_1 =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: []
      )

    invocation_2 =
      TxAuthorizedInvocation.new(
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: [invocation_1]
      )

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
      ed25519_contract_id:
        TxEd25519ContractID.new(network_id: network_id, ed25519: ed25519, salt: salt),
      struct_contract_id:
        TxStructContractID.new(network_id: network_id, contract_id: contract_id, salt: salt),
      from_asset: TxFromAsset.new(network_id: network_id, asset: asset),
      source_account_contract_id:
        TxSourceAccountContractID.new(
          network_id: network_id,
          source_account: public_key,
          salt: salt
        ),
      hash_id_preimage_create_contract_arg_wasm_ref:
        TxHashIDPreimageCreateContractArgs.new(
          network_id: network_id,
          source: wasm_ref_sc_contract_code,
          salt: salt
        ),
      hash_id_preimage_create_contract_arg_token:
        TxHashIDPreimageCreateContractArgs.new(
          network_id: network_id,
          source: token_sc_contract_code,
          salt: salt
        ),
      hash_id_preimage_contract_auth:
        TxHashIDPreimageContractAuth.new(
          network_id: network_id,
          nonce: nonce,
          invocation: invocation_2
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

  test "new/1 when type is contract_id_from_ed25519", %{ed25519_contract_id: ed25519_contract_id} do
    %TxHashIDPreimage{type: :contract_id_from_ed25519, value: ^ed25519_contract_id} =
      TxHashIDPreimage.new(contract_id_from_ed25519: ed25519_contract_id)
  end

  test "new/1 when contract_id_from_ed25519 value is wrong" do
    {:error, :invalid_contract_id_from_ed25519} =
      TxHashIDPreimage.new(contract_id_from_ed25519: :wrong_value)
  end

  test "new/1 when type is contract_id_from_contract", %{struct_contract_id: struct_contract_id} do
    %TxHashIDPreimage{type: :contract_id_from_contract, value: ^struct_contract_id} =
      TxHashIDPreimage.new(contract_id_from_contract: struct_contract_id)
  end

  test "new/1 when contract_id_from_contract value is wrong" do
    {:error, :invalid_contract_id_from_contract} =
      TxHashIDPreimage.new(contract_id_from_contract: :wrong_value)
  end

  test "new/1 when type is contract_id_from_asset", %{from_asset: from_asset} do
    %TxHashIDPreimage{type: :contract_id_from_asset, value: ^from_asset} =
      TxHashIDPreimage.new(contract_id_from_asset: from_asset)
  end

  test "new/1 when contract_id_from_asset value is wrong" do
    {:error, :invalid_contract_id_from_asset} =
      TxHashIDPreimage.new(contract_id_from_asset: :wrong_value)
  end

  test "new/1 when type is contact_id_from_source_acc", %{
    source_account_contract_id: source_account_contract_id
  } do
    %TxHashIDPreimage{type: :contact_id_from_source_acc, value: ^source_account_contract_id} =
      TxHashIDPreimage.new(contact_id_from_source_acc: source_account_contract_id)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_hash_id_preimage_type} = TxHashIDPreimage.new("invalid_args")
  end

  test "new/1 when contact_id_from_source_acc value is wrong" do
    {:error, :invalid_contact_id_from_source_acc} =
      TxHashIDPreimage.new(contact_id_from_source_acc: :wrong_value)
  end

  test "new/1 when type is create_contract_args and the code is wasm_ref", %{
    hash_id_preimage_create_contract_arg_wasm_ref: hash_id_preimage_create_contract_arg
  } do
    %TxHashIDPreimage{type: :create_contract_args, value: ^hash_id_preimage_create_contract_arg} =
      TxHashIDPreimage.new(create_contract_args: hash_id_preimage_create_contract_arg)
  end

  test "new/1 when type is create_contract_args and the code is token", %{
    hash_id_preimage_create_contract_arg_token: hash_id_preimage_create_contract_arg
  } do
    %TxHashIDPreimage{type: :create_contract_args, value: ^hash_id_preimage_create_contract_arg} =
      TxHashIDPreimage.new(create_contract_args: hash_id_preimage_create_contract_arg)
  end

  test "new/1 when create_contract_args value is wrong" do
    {:error, :invalid_create_contract_args} =
      TxHashIDPreimage.new(create_contract_args: :wrong_value)
  end

  test "new/1 when type is contract_auth", %{
    hash_id_preimage_contract_auth: hash_id_preimage_contract_auth
  } do
    %TxHashIDPreimage{type: :contract_auth, value: ^hash_id_preimage_contract_auth} =
      TxHashIDPreimage.new(contract_auth: hash_id_preimage_contract_auth)
  end

  test "new/1 when contract_auth value is wrong" do
    {:error, :invalid_contract_auth} = TxHashIDPreimage.new(contract_auth: :wrong_value)
  end

  test "to_xdr/1 when type is op_id", %{operation_id: operation_id} do
    %HashIDPreimage{
      hash_id: %OperationID{
        op_num: %UInt32{datum: 123},
        sequence_number: %SequenceNumber{sequence_number: 123_456_789},
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
      hash_id: %RevokeID{
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
        sequence_number: %SequenceNumber{sequence_number: 123_456_789},
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

  test "to_xdr/1 when type is contract_id_from_ed25519", %{
    ed25519_contract_id: ed25519_contract_id
  } do
    %HashIDPreimage{
      hash_id: %Ed25519ContractID{
        ed25519: %UInt256{datum: 456},
        network_id: %Hash{value: "network_id"},
        salt: %UInt256{datum: 456}
      },
      type: %EnvelopeType{
        identifier: :ENVELOPE_TYPE_CONTRACT_ID_FROM_ED25519
      }
    } =
      TxHashIDPreimage.new(contract_id_from_ed25519: ed25519_contract_id)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is contract_id_from_contract", %{
    struct_contract_id: struct_contract_id
  } do
    %HashIDPreimage{
      hash_id: %StructContractID{
        network_id: %Hash{value: "network_id"},
        contract_id: %Hash{
          value: "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
        },
        salt: %UInt256{datum: 456}
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_POOL_REVOKE_OP_ID}
    } =
      TxHashIDPreimage.new(contract_id_from_contract: struct_contract_id)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is contract_id_from_asset", %{from_asset: from_asset} do
    %HashIDPreimage{
      hash_id: %FromAsset{
        network_id: %Hash{value: "network_id"},
        asset: %Asset{
          asset: %Void{value: nil},
          type: %AssetType{identifier: :ASSET_TYPE_NATIVE}
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_CONTRACT_ID_FROM_ASSET}
    } =
      TxHashIDPreimage.new(contract_id_from_asset: from_asset)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is contact_id_from_source_acc", %{
    source_account_contract_id: source_account_contract_id
  } do
    %HashIDPreimage{
      hash_id: %SourceAccountContractID{
        network_id: %Hash{value: "network_id"},
        salt: %UInt256{datum: 456},
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
      type: %EnvelopeType{
        identifier: :ENVELOPE_TYPE_CONTRACT_ID_FROM_SOURCE_ACCOUNT
      }
    } =
      TxHashIDPreimage.new(contact_id_from_source_acc: source_account_contract_id)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is create_contract_args", %{
    hash_id_preimage_create_contract_arg_token: hash_id_preimage_create_contract_arg
  } do
    %HashIDPreimage{
      hash_id: %HashIDPreimageCreateContractArgs{
        network_id: %Hash{value: "network_id"},
        salt: %UInt256{datum: 456},
        source: %SCContractCode{
          contract_code: %Void{value: nil},
          type: %SCContractCodeType{
            identifier: :SCCONTRACT_CODE_TOKEN
          }
        }
      },
      type: %EnvelopeType{
        identifier: :ENVELOPE_TYPE_CREATE_CONTRACT_ARGS
      }
    } =
      TxHashIDPreimage.new(create_contract_args: hash_id_preimage_create_contract_arg)
      |> TxHashIDPreimage.to_xdr()
  end

  test "to_xdr/1 when type is contract_auth", %{
    hash_id_preimage_contract_auth: hash_id_preimage_contract_auth
  } do
    %HashIDPreimage{
      hash_id: %HashIDPreimageContractAuth{
        network_id: %Hash{value: "network_id"},
        nonce: %UInt64{datum: 987},
        invocation: %AuthorizedInvocation{
          contract_id: %Hash{
            value:
              <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75, 68, 84,
                157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
          },
          function_name: %SCSymbol{value: "function_name"},
          args: %SCVec{
            sc_vals: [
              %SCVal{
                value: %Int32{datum: 654},
                type: %SCValType{identifier: :SCV_I32}
              }
            ]
          },
          sub_invocations: %AuthorizedInvocationList{
            sub_invocations: [
              %AuthorizedInvocation{
                contract_id: %Hash{
                  value:
                    <<4, 97, 22, 140, 187, 174, 13, 169, 108, 84, 59, 113, 253, 87, 26, 236, 75,
                      68, 84, 157, 80, 63, 154, 249, 231, 104, 92, 206, 219, 193, 97, 60>>
                },
                function_name: %SCSymbol{value: "function_name"},
                args: %SCVec{
                  sc_vals: [
                    %SCVal{
                      value: %Int32{datum: 654},
                      type: %SCValType{identifier: :SCV_I32}
                    }
                  ]
                },
                sub_invocations: %AuthorizedInvocationList{sub_invocations: []}
              }
            ]
          }
        }
      },
      type: %EnvelopeType{identifier: :ENVELOPE_TYPE_CONTRACT_AUTH}
    } =
      TxHashIDPreimage.new(contract_auth: hash_id_preimage_contract_auth)
      |> TxHashIDPreimage.to_xdr()
  end
end
