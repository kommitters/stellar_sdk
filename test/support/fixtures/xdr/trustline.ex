defmodule Stellar.Test.Fixtures.XDR.Trustline do
  @moduledoc """
  XDR constructions for Trustline.
  """

  alias StellarBase.XDR.{
    AccountID,
    AlphaNum12,
    AlphaNum4,
    Asset,
    AssetCode4,
    AssetCode12,
    AssetType,
    OperationBody,
    OperationType,
    Operations.SetTrustLineFlags,
    PoolID,
    PublicKey,
    PublicKeyType,
    TrustLineAsset,
    UInt32,
    UInt256,
    Void
  }

  @type trustor :: String.t()
  @type asset :: tuple()
  @type clear_flags :: list()
  @type set_flags :: list()
  @type trustline_asset :: :native | Keyword.t()
  @type xdr :: OperationBody.t()

  @spec set_trustline_flags(
          trustor :: trustor(),
          asset :: asset(),
          set_flags :: set_flags(),
          clear_flags :: clear_flags()
        ) :: xdr()
  def set_trustline_flags(
        "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
        {"BTCN", "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"},
        [:authorized, :maintain_liabilities],
        []
      ) do
    %OperationBody{
      operation: %SetTrustLineFlags{
        asset: %Asset{
          asset: %AlphaNum4{
            asset_code: %AssetCode4{code: "BTCN", length: 4},
            issuer: %AccountID{
              account_id: %PublicKey{
                public_key: %UInt256{
                  datum:
                    <<102, 109, 61, 201, 173, 101, 16, 194, 89, 168, 54, 140, 36, 153, 76, 22,
                      249, 162, 181, 195, 177, 21, 207, 36, 1, 10, 22, 85, 255, 214, 103, 12>>
                },
                type: %PublicKeyType{
                  identifier: :PUBLIC_KEY_TYPE_ED25519
                }
              }
            }
          },
          type: %AssetType{identifier: :ASSET_TYPE_CREDIT_ALPHANUM4}
        },
        clear_flags: %UInt32{datum: 0},
        set_flags: %UInt32{datum: 3},
        trustor: %AccountID{
          account_id: %PublicKey{
            public_key: %UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            },
            type: %PublicKeyType{
              identifier: :PUBLIC_KEY_TYPE_ED25519
            }
          }
        }
      },
      type: %OperationType{identifier: :SET_TRUST_LINE_FLAGS}
    }
  end

  @spec trustline_asset(asset :: trustline_asset()) :: TrustLineAsset.t()
  def trustline_asset(:native) do
    %TrustLineAsset{
      asset: %Void{value: nil},
      type: %AssetType{identifier: :ASSET_TYPE_NATIVE}
    }
  end

  def trustline_asset(
        code: "BTCN",
        issuer: "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
      ) do
    %TrustLineAsset{
      asset: %AlphaNum4{
        asset_code: %AssetCode4{code: "BTCN", length: 4},
        issuer: %AccountID{
          account_id: %PublicKey{
            public_key: %UInt256{
              datum:
                <<102, 109, 61, 201, 173, 101, 16, 194, 89, 168, 54, 140, 36, 153, 76, 22, 249,
                  162, 181, 195, 177, 21, 207, 36, 1, 10, 22, 85, 255, 214, 103, 12>>
            },
            type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        }
      },
      type: %AssetType{identifier: :ASSET_TYPE_CREDIT_ALPHANUM4}
    }
  end

  def trustline_asset(
        code: "BTCNEW20000",
        issuer: "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
      ) do
    %TrustLineAsset{
      asset: %AlphaNum12{
        asset_code: %AssetCode12{code: "BTCNEW20000", length: 11},
        issuer: %AccountID{
          account_id: %PublicKey{
            public_key: %UInt256{
              datum:
                <<102, 109, 61, 201, 173, 101, 16, 194, 89, 168, 54, 140, 36, 153, 76, 22, 249,
                  162, 181, 195, 177, 21, 207, 36, 1, 10, 22, 85, 255, 214, 103, 12>>
            },
            type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        }
      },
      type: %AssetType{identifier: :ASSET_TYPE_CREDIT_ALPHANUM12}
    }
  end

  def trustline_asset(pool_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072") do
    %TrustLineAsset{
      asset: %PoolID{
        value:
          <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49, 141,
            141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
      },
      type: %AssetType{identifier: :ASSET_TYPE_POOL_SHARE}
    }
  end
end
