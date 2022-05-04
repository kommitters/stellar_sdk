defmodule Stellar.Test.Fixtures.XDR.Ledger do
  @moduledoc """
  XDR constructions for Ledger entries.
  """
  alias StellarBase.XDR.{
    Account,
    AccountID,
    AlphaNum4,
    AlphaNum12,
    AssetCode4,
    AssetCode12,
    AssetType,
    ClaimableBalance,
    ClaimableBalanceID,
    ClaimableBalanceIDType,
    Data,
    Hash,
    Int64,
    LiquidityPool,
    Offer,
    PoolID,
    PublicKey,
    PublicKeyType,
    String64,
    TrustLine,
    TrustLineAsset,
    UInt256,
    Void
  }

  @type account_id :: String.t()
  @type asset :: atom() | Keyword.t()
  @type claimable_balance_id :: String.t()
  @type liquidity_pool_id :: String.t()
  @type offer_id :: non_neg_integer()

  @spec ledger_account(account_id :: account_id()) :: Account.t()
  def ledger_account("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS") do
    %Account{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      }
    }
  end

  @spec ledger_claimable_balance(claimable_balance_id :: claimable_balance_id()) ::
          ClaimableBalance.t()
  def ledger_claimable_balance(
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %ClaimableBalance{
      balance_id: %ClaimableBalanceID{
        claimable_balance_id: %Hash{
          value:
            <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
              141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
        },
        type: %ClaimableBalanceIDType{identifier: :CLAIMABLE_BALANCE_ID_TYPE_V0}
      }
    }
  end

  @spec ledger_liquidity_pool(liquidity_pool_id :: liquidity_pool_id()) :: LiquidityPool.t()
  def ledger_liquidity_pool("929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072") do
    %LiquidityPool{
      liquidity_pool_id: %PoolID{
        value:
          <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49, 141,
            141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
      }
    }
  end

  @spec ledger_offer(seller_id :: account_id(), offer_id :: offer_id()) :: Offer.t()
  def ledger_offer("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS", 123) do
    %Offer{
      offer_id: %Int64{datum: 123},
      seller_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      }
    }
  end

  @spec ledger_data(account_id :: account_id(), data :: String.t()) :: Data.t()
  def ledger_data("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS", "test") do
    %Data{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      data_name: %String64{value: "test"}
    }
  end

  @spec ledger_trustline(account_id :: account_id(), asset :: asset()) :: Trustline.t()
  def ledger_trustline("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS", :native) do
    %TrustLine{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      asset: %TrustLineAsset{
        asset: %Void{value: nil},
        type: %AssetType{identifier: :ASSET_TYPE_NATIVE}
      }
    }
  end

  def ledger_trustline("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
        code: "BTCN",
        issuer: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      ) do
    %TrustLine{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      asset: %TrustLineAsset{
        asset: %AlphaNum4{
          asset_code: %AssetCode4{code: "BTCN", length: 4},
          issuer: %AccountID{
            account_id: %PublicKey{
              public_key: %UInt256{
                datum:
                  <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93,
                    18, 18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
              },
              type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
            }
          }
        },
        type: %AssetType{identifier: :ASSET_TYPE_CREDIT_ALPHANUM4}
      }
    }
  end

  def ledger_trustline("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
        code: "BTCNEW2000",
        issuer: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      ) do
    %TrustLine{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      asset: %TrustLineAsset{
        asset: %AlphaNum12{
          asset_code: %AssetCode12{code: "BTCNEW2000", length: 10},
          issuer: %AccountID{
            account_id: %PublicKey{
              public_key: %UInt256{
                datum:
                  <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93,
                    18, 18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
              },
              type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
            }
          }
        },
        type: %AssetType{identifier: :ASSET_TYPE_CREDIT_ALPHANUM12}
      }
    }
  end

  def ledger_trustline("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
        pool_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %TrustLine{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      asset: %TrustLineAsset{
        asset: %PoolID{
          value:
            <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
              141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
        },
        type: %AssetType{identifier: :ASSET_TYPE_POOL_SHARE}
      }
    }
  end
end
