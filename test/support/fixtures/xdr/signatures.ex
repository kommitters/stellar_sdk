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
  def sha256_hash_signer_key("XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC") do
    %SignerKey{
      signer_key: %UInt256{
        datum:
          <<166, 253, 99, 166, 207, 231, 51, 29, 108, 218, 82, 161, 161, 241, 223, 129, 248, 20,
            182, 229, 112, 154, 211, 208, 111, 24, 212, 20, 168, 1, 184, 145>>
      },
      type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
    }
  end

  @spec pre_auth_signer_key(key :: key()) :: SignerKey.t()
  def pre_auth_signer_key("TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B") do
    %SignerKey{
      signer_key: %UInt256{
        datum:
          <<170, 83, 38, 205, 9, 126, 182, 138, 252, 59, 73, 56, 31, 230, 190, 41, 122, 35, 34,
            164, 197, 158, 190, 244, 150, 118, 164, 216, 146, 173, 218, 44>>
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
  def sha256_hash_signer("XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC", 2) do
    %Signer{
      key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<166, 253, 99, 166, 207, 231, 51, 29, 108, 218, 82, 161, 161, 241, 223, 129, 248, 20,
              182, 229, 112, 154, 211, 208, 111, 24, 212, 20, 168, 1, 184, 145>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
      },
      weight: %UInt32{datum: 2}
    }
  end

  @spec pre_auth_signer(key :: key(), weight :: weight()) :: Signer.t()
  def pre_auth_signer("TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B", 2) do
    %Signer{
      key: %SignerKey{
        signer_key: %UInt256{
          datum:
            <<170, 83, 38, 205, 9, 126, 182, 138, 252, 59, 73, 56, 31, 230, 190, 41, 122, 35, 34,
              164, 197, 158, 190, 244, 150, 118, 164, 216, 146, 173, 218, 44>>
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
        "XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC"
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
            <<166, 253, 99, 166, 207, 231, 51, 29, 108, 218, 82, 161, 161, 241, 223, 129, 248, 20,
              182, 229, 112, 154, 211, 208, 111, 24, 212, 20, 168, 1, 184, 145>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_HASH_X}
      }
    }
  end

  @spec pre_auth_revoke_sponsorship_signer(account_id :: account_id(), key :: key()) :: Signer.t()
  def pre_auth_revoke_sponsorship_signer(
        "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35",
        "TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B"
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
            <<170, 83, 38, 205, 9, 126, 182, 138, 252, 59, 73, 56, 31, 230, 190, 41, 122, 35, 34,
              164, 197, 158, 190, 244, 150, 118, 164, 216, 146, 173, 218, 44>>
        },
        type: %SignerKeyType{identifier: :SIGNER_KEY_TYPE_PRE_AUTH_TX}
      }
    }
  end
end
