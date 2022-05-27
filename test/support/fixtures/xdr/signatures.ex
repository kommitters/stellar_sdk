defmodule Stellar.Test.Fixtures.XDR.Signatures do
  @moduledoc """
  XDR constructions for Signatures.
  """
  alias StellarBase.XDR.{
    AccountID,
    PublicKey,
    PublicKeyType,
    RevokeSponsorshipSigner,
    Signer,
    SignerKey,
    SignerKeyType,
    UInt32,
    UInt256
  }

  @type key :: String.t()
  @type account_id :: String.t()
  @type weight :: non_neg_integer()

  @spec ed25519_signer_key(key :: key()) :: SignerKey.t()
  def ed25519_signer_key("GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V") do
    %SignerKey{
      signer_key: %UInt256{
        datum:
          <<102, 109, 61, 201, 173, 101, 16, 194, 89, 168, 54, 140, 36, 153, 76, 22, 249, 162,
            181, 195, 177, 21, 207, 36, 1, 10, 22, 85, 255, 214, 103, 12>>
      },
      type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_ED25519}
    }
  end

  @spec sha256_hash_signer_key(key :: key()) :: SignerKey.t()
  def sha256_hash_signer_key("a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891") do
    %SignerKey{
      signer_key: %UInt256{
        datum:
          <<96, 32, 44, 48, 184, 229, 155, 78, 132, 15, 137, 159, 150, 227, 254, 194, 40, 25, 238,
            227, 176, 40, 237, 157, 78, 175, 209, 79, 238, 15, 4, 147>>
      },
      type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
    }
  end

  @spec pre_auth_signer_key(key :: key()) :: SignerKey.t()
  def pre_auth_signer_key("aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c") do
    %SignerKey{
      signer_key: %UInt256{
        datum:
          <<133, 110, 87, 99, 144, 85, 92, 230, 23, 25, 242, 166, 145, 55, 101, 181, 195, 71, 203,
            217, 210, 129, 106, 91, 103, 124, 121, 106, 171, 102, 203, 7>>
      },
      type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_PRE_AUTH_TX}
    }
  end

  @spec ed25519_signer(key :: key(), weight :: weight()) :: Signer.t()
  def ed25519_signer("GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V", 2) do
    %Signer{
      key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<102, 109, 61, 201, 173, 101, 16, 194, 89, 168, 54, 140, 36, 153, 76, 22, 249, 162,
              181, 195, 177, 21, 207, 36, 1, 10, 22, 85, 255, 214, 103, 12>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_ED25519}
      },
      weight: %UInt32{datum: 2}
    }
  end

  @spec sha256_hash_signer(key :: key(), weight :: weight()) :: Signer.t()
  def sha256_hash_signer("a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891", 2) do
    %Signer{
      key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<96, 32, 44, 48, 184, 229, 155, 78, 132, 15, 137, 159, 150, 227, 254, 194, 40, 25,
              238, 227, 176, 40, 237, 157, 78, 175, 209, 79, 238, 15, 4, 147>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
      },
      weight: %UInt32{datum: 2}
    }
  end

  @spec pre_auth_signer(key :: key(), weight :: weight()) :: Signer.t()
  def pre_auth_signer("aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c", 2) do
    %Signer{
      key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<133, 110, 87, 99, 144, 85, 92, 230, 23, 25, 242, 166, 145, 55, 101, 181, 195, 71,
              203, 217, 210, 129, 106, 91, 103, 124, 121, 106, 171, 102, 203, 7>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_PRE_AUTH_TX}
      },
      weight: %UInt32{datum: 2}
    }
  end

  @spec ed25519_revoke_sponsorship_signer(account_id :: account_id(), key :: key()) :: Signer.t()
  def ed25519_revoke_sponsorship_signer(
        "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35",
        "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
      ) do
    %RevokeSponsorshipSigner{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<192, 79, 187, 120, 75, 5, 241, 56, 153, 91, 211, 143, 59, 27, 127, 172, 99, 200,
                224, 220, 50, 125, 7, 157, 242, 111, 94, 84, 100, 76, 65, 73>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      signer_key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<102, 109, 61, 201, 173, 101, 16, 194, 89, 168, 54, 140, 36, 153, 76, 22, 249, 162,
              181, 195, 177, 21, 207, 36, 1, 10, 22, 85, 255, 214, 103, 12>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_ED25519}
      }
    }
  end

  @spec sha256_hash_revoke_sponsorship_signer(account_id :: account_id(), key :: key()) ::
          Signer.t()
  def sha256_hash_revoke_sponsorship_signer(
        "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35",
        "a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891"
      ) do
    %RevokeSponsorshipSigner{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<192, 79, 187, 120, 75, 5, 241, 56, 153, 91, 211, 143, 59, 27, 127, 172, 99, 200,
                224, 220, 50, 125, 7, 157, 242, 111, 94, 84, 100, 76, 65, 73>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      signer_key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<96, 32, 44, 48, 184, 229, 155, 78, 132, 15, 137, 159, 150, 227, 254, 194, 40, 25,
              238, 227, 176, 40, 237, 157, 78, 175, 209, 79, 238, 15, 4, 147>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
      }
    }
  end

  @spec pre_auth_revoke_sponsorship_signer(account_id :: account_id(), key :: key()) :: Signer.t()
  def pre_auth_revoke_sponsorship_signer(
        "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35",
        "aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c"
      ) do
    %RevokeSponsorshipSigner{
      account_id: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<192, 79, 187, 120, 75, 5, 241, 56, 153, 91, 211, 143, 59, 27, 127, 172, 99, 200,
                224, 220, 50, 125, 7, 157, 242, 111, 94, 84, 100, 76, 65, 73>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      signer_key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<133, 110, 87, 99, 144, 85, 92, 230, 23, 25, 242, 166, 145, 55, 101, 181, 195, 71,
              203, 217, 210, 129, 106, 91, 103, 124, 121, 106, 171, 102, 203, 7>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_PRE_AUTH_TX}
      }
    }
  end
end
