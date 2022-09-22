defmodule Stellar.TxBuild.SignatureTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [decorated_signature_xdr: 2, decorated_signature_xdr: 3]

  alias Stellar.KeyPair
  alias Stellar.TxBuild.Signature

  describe "signature type :ed25519" do
    setup do
      public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      secret = "SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z"
      raw_public_key = KeyPair.raw_public_key(public_key)
      raw_secret = KeyPair.raw_secret_seed(secret)
      hint = <<196, 132, 98, 77>>

      %{
        public_key: public_key,
        raw_public_key: raw_public_key,
        secret: secret,
        raw_secret: raw_secret,
        hint: hint,
        signature: Signature.new({public_key, secret})
      }
    end

    test "new/2", %{public_key: public_key, secret: secret, raw_secret: raw_secret, hint: hint} do
      %Signature{type: :ed25519, key: ^secret, raw_key: ^raw_secret, hint: ^hint} =
        Signature.new({public_key, secret})
    end

    test "to_xdr/2", %{signature: signature, secret: raw_secret, hint: hint} do
      signature_xdr = decorated_signature_xdr(raw_secret, hint, <<0, 0, 0, 0>>)
      ^signature_xdr = Signature.to_xdr(signature, <<0, 0, 0, 0>>)
    end

    test "to_xdr/1", %{signature: signature, raw_secret: raw_secret, hint: hint} do
      signature_xdr = decorated_signature_xdr(raw_secret, hint)
      ^signature_xdr = Signature.to_xdr(signature)
    end
  end
end
