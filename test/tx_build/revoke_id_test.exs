defmodule Stellar.TxBuild.RevokeIDTest do
  use ExUnit.Case

  alias Stellar.TxBuild.RevokeID, as: TxRevokeID
  alias Stellar.TxBuild.SequenceNumber, as: TxSequenceNumber
  alias Stellar.TxBuild.PoolID, as: TxPoolID
  alias Stellar.TxBuild.Asset, as: TxAsset
  alias Stellar.TxBuild.AccountID, as: TxAccountID

  alias StellarBase.XDR.{
    AccountID,
    AlphaNum4,
    Asset,
    AssetCode4,
    AssetType,
    PublicKey,
    PublicKeyType,
    PoolID,
    RevokeID,
    SequenceNumber,
    UInt32,
    UInt256
  }

  setup do
    public_key = "GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN"
    sequence_number_value = 123
    pool_id_value = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    # ASSET
    issuer_public_key = "GCQDWMVBF4MQ4D56MJHJI6OKNY2FZRNLV2UYZXAEPXHK6VIMT2NZRFSC"
    asset = TxAsset.new(code: "ABC", issuer: issuer_public_key)

    %{
      public_key: public_key,
      sequence_number_value: sequence_number_value,
      pool_id_value: pool_id_value,
      source_account: TxAccountID.new(public_key),
      sequence_number: TxSequenceNumber.new(sequence_number_value),
      op_num: 123,
      liquidity_pool_id: TxPoolID.new(pool_id_value),
      asset: asset
    }
  end

  test "new/1", %{
    source_account: source_account,
    sequence_number: sequence_number,
    op_num: op_num,
    liquidity_pool_id: liquidity_pool_id,
    asset: asset
  } do
    %TxRevokeID{
      source_account: ^source_account,
      sequence_number: ^sequence_number,
      op_num: ^op_num,
      liquidity_pool_id: ^liquidity_pool_id,
      asset: ^asset
    } = TxRevokeID.new([source_account, sequence_number, op_num, liquidity_pool_id, asset])
  end

  test "new/1 when invalid revoke id" do
    {:error, :invalid_revoke_id} = TxRevokeID.new("invalid_revoke_id")
  end

  test "to_xdr/1", %{
    source_account: source_account,
    sequence_number: sequence_number,
    op_num: op_num,
    liquidity_pool_id: liquidity_pool_id,
    asset: asset
  } do
    %RevokeID{
      source_account: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<35, 91, 203, 138, 180, 145, 234, 66, 217, 94, 128, 4, 7, 74, 31, 24, 11, 155, 95,
                195, 137, 228, 19, 220, 153, 243, 25, 2, 64, 172, 119, 151>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      sequence_number: %SequenceNumber{sequence_number: 123},
      op_num: %UInt32{datum: 123},
      liquidity_pool_id: %PoolID{
        value:
          <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49, 141,
            141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
      },
      asset: %Asset{
        asset: %AlphaNum4{
          asset_code: %AssetCode4{code: "ABC", length: 3},
          issuer: %AccountID{
            account_id: %PublicKey{
              public_key: %UInt256{
                datum:
                  <<160, 59, 50, 161, 47, 25, 14, 15, 190, 98, 78, 148, 121, 202, 110, 52, 92,
                    197, 171, 174, 169, 140, 220, 4, 125, 206, 175, 85, 12, 158, 155, 152>>
              },
              type: %PublicKeyType{
                identifier: :PUBLIC_KEY_TYPE_ED25519
              }
            }
          }
        },
        type: %AssetType{identifier: :ASSET_TYPE_CREDIT_ALPHANUM4}
      }
    } =
      TxRevokeID.new([source_account, sequence_number, op_num, liquidity_pool_id, asset])
      |> TxRevokeID.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_revoke_id} = TxRevokeID.to_xdr("invalid_struct")
  end
end
