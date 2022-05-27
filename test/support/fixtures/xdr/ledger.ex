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
    LedgerEntryType,
    LedgerKey,
    LiquidityPool,
    Offer,
    PoolID,
    PublicKey,
    PublicKeyType,
    RevokeSponsorship,
    RevokeSponsorshipType,
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

  @spec ledger_key_account(account_id :: account_id()) :: LedgerKey.t()
  def ledger_key_account("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS") do
    %LedgerKey{
      entry: %Account{
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
      },
      type: %LedgerEntryType{identifier: :ACCOUNT}
    }
  end

  @spec ledger_key_trustline(account_id :: account_id(), asset :: asset()) :: LedgerKey.t()
  def ledger_key_trustline("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS", :native) do
    %StellarBase.XDR.LedgerKey{
      entry: %StellarBase.XDR.TrustLine{
        account_id: %StellarBase.XDR.AccountID{
          account_id: %StellarBase.XDR.PublicKey{
            public_key: %StellarBase.XDR.UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            },
            type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        },
        asset: %StellarBase.XDR.TrustLineAsset{
          asset: %StellarBase.XDR.Void{value: nil},
          type: %StellarBase.XDR.AssetType{identifier: :ASSET_TYPE_NATIVE}
        }
      },
      type: %StellarBase.XDR.LedgerEntryType{identifier: :TRUSTLINE}
    }
  end

  @spec ledger_key_offer(seller_id :: account_id(), offer_id :: offer_id()) :: LedgerKey.t()
  def ledger_key_offer("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS", 123) do
    %StellarBase.XDR.LedgerKey{
      entry: %StellarBase.XDR.Offer{
        offer_id: %StellarBase.XDR.Int64{datum: 123},
        seller_id: %StellarBase.XDR.AccountID{
          account_id: %StellarBase.XDR.PublicKey{
            public_key: %StellarBase.XDR.UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            },
            type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        }
      },
      type: %StellarBase.XDR.LedgerEntryType{identifier: :OFFER}
    }
  end

  @spec ledger_key_data(account_id :: account_id(), data :: String.t()) :: LedgerKey.t()
  def ledger_key_data("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS", "test") do
    %StellarBase.XDR.LedgerKey{
      entry: %StellarBase.XDR.Data{
        account_id: %StellarBase.XDR.AccountID{
          account_id: %StellarBase.XDR.PublicKey{
            public_key: %StellarBase.XDR.UInt256{
              datum:
                <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93, 18,
                  18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
            },
            type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
          }
        },
        data_name: %StellarBase.XDR.String64{value: "test"}
      },
      type: %StellarBase.XDR.LedgerEntryType{identifier: :DATA}
    }
  end

  @spec ledger_key_claimable_balance(claimable_balance_id :: claimable_balance_id()) ::
          LedgerKey.t()
  def ledger_key_claimable_balance(
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %StellarBase.XDR.LedgerKey{
      entry: %StellarBase.XDR.ClaimableBalance{
        balance_id: %StellarBase.XDR.ClaimableBalanceID{
          claimable_balance_id: %StellarBase.XDR.Hash{
            value:
              <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
                141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
          },
          type: %StellarBase.XDR.ClaimableBalanceIDType{identifier: :CLAIMABLE_BALANCE_ID_TYPE_V0}
        }
      },
      type: %StellarBase.XDR.LedgerEntryType{identifier: :CLAIMABLE_BALANCE}
    }
  end

  @spec ledger_key_liquidity_pool(liquidity_pool_id :: liquidity_pool_id()) :: LedgerKey.t()
  def ledger_key_liquidity_pool(
        "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
      ) do
    %StellarBase.XDR.LedgerKey{
      entry: %StellarBase.XDR.LiquidityPool{
        liquidity_pool_id: %StellarBase.XDR.PoolID{
          value:
            <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
              141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
        }
      },
      type: %StellarBase.XDR.LedgerEntryType{identifier: :LIQUIDITY_POOL}
    }
  end

  @spec revoke_sponsorship(type :: atom(), args :: Keyword.t()) :: RevokeSponsorship.t()
  def revoke_sponsorship(:account,
        account_id: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      ) do
    %StellarBase.XDR.OperationBody{
      operation: %StellarBase.XDR.Operations.RevokeSponsorship{
        sponsorship: %StellarBase.XDR.LedgerKey{
          entry: %StellarBase.XDR.Account{
            account_id: %StellarBase.XDR.AccountID{
              account_id: %StellarBase.XDR.PublicKey{
                public_key: %StellarBase.XDR.UInt256{
                  datum:
                    <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93,
                      18, 18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
                },
                type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
              }
            }
          },
          type: %StellarBase.XDR.LedgerEntryType{identifier: :ACCOUNT}
        },
        type: %StellarBase.XDR.RevokeSponsorshipType{identifier: :REVOKE_SPONSORSHIP_LEDGER_ENTRY}
      },
      type: %StellarBase.XDR.OperationType{identifier: :REVOKE_SPONSORSHIP}
    }
  end

  def revoke_sponsorship(:signer,
        account_id: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS",
        ed25519: "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35"
      ) do
    %StellarBase.XDR.OperationBody{
      operation: %StellarBase.XDR.Operations.RevokeSponsorship{
        sponsorship: %StellarBase.XDR.RevokeSponsorshipSigner{
          account_id: %StellarBase.XDR.AccountID{
            account_id: %StellarBase.XDR.PublicKey{
              public_key: %StellarBase.XDR.UInt256{
                datum:
                  <<255, 175, 19, 218, 55, 141, 192, 52, 246, 58, 33, 51, 245, 109, 97, 106, 93,
                    18, 18, 37, 209, 48, 248, 121, 16, 166, 170, 211, 196, 132, 98, 77>>
              },
              type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
            }
          },
          signer_key: %StellarBase.XDR.SignerKey{
            signer_key: %StellarBase.XDR.UInt256{
              datum:
                <<192, 79, 187, 120, 75, 5, 241, 56, 153, 91, 211, 143, 59, 27, 127, 172, 99, 200,
                  224, 220, 50, 125, 7, 157, 242, 111, 94, 84, 100, 76, 65, 73>>
            },
            type: %StellarBase.XDR.SignerKeyType{identifier: :SIGNER_KEY_TYPE_ED25519}
          }
        },
        type: %RevokeSponsorshipType{identifier: :REVOKE_SPONSORSHIP_SIGNER}
      },
      type: %StellarBase.XDR.OperationType{identifier: :REVOKE_SPONSORSHIP}
    }
  end
end
