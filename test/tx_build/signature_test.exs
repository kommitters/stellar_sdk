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

    test "new/2 with keypair", %{
      public_key: public_key,
      secret: secret,
      raw_secret: raw_secret,
      hint: hint
    } do
      %Signature{type: :ed25519, key: ^secret, raw_key: ^raw_secret, hint: ^hint} =
        Signature.new({public_key, secret})
    end

    test "new/2 with secret", %{secret: secret, raw_secret: raw_secret, hint: hint} do
      %Signature{type: :ed25519, key: ^secret, raw_key: ^raw_secret, hint: ^hint} =
        Signature.new(ed25519: secret)
    end

    test "to_xdr/1", %{signature: signature, raw_secret: raw_secret, hint: hint} do
      signature_xdr = decorated_signature_xdr(raw_secret, hint)
      ^signature_xdr = Signature.to_xdr(signature)
    end

    test "to_xdr/2", %{signature: signature, secret: raw_secret, hint: hint} do
      signature_xdr = decorated_signature_xdr(raw_secret, hint, <<0, 0, 0, 0>>)
      ^signature_xdr = Signature.to_xdr(signature, <<0, 0, 0, 0>>)
    end
  end

  describe "signature type :hash_x" do
    setup do
      preimage = "47eaeab9b381bdb8d15bc3ef50ef5860bd4fcb8b1a15e6e5d22fa7386d9322e0"
      hint = <<205, 0, 141, 56>>

      raw_preimage =
        <<71, 234, 234, 185, 179, 129, 189, 184, 209, 91, 195, 239, 80, 239, 88, 96, 189, 79, 203,
          139, 26, 21, 230, 229, 210, 47, 167, 56, 109, 147, 34, 224>>

      %{
        preimage: preimage,
        raw_preimage: raw_preimage,
        hint: hint,
        signature: Signature.new(hash_x: preimage)
      }
    end

    test "new/1", %{preimage: preimage, raw_preimage: raw_preimage, hint: hint} do
      %Signature{type: :hash_x, key: ^preimage, raw_key: ^raw_preimage, hint: ^hint} =
        Signature.new(hash_x: preimage)
    end

    test "to_xdr/1", %{signature: signature, raw_preimage: raw_preimage, hint: hint} do
      signature_xdr = decorated_signature_xdr(raw_preimage, hint)
      ^signature_xdr = Signature.to_xdr(signature)
    end

    test "to_xdr/2", %{signature: signature, preimage: raw_preimage, hint: hint} do
      signature_xdr = Signature.to_xdr(signature)
      ^signature_xdr = Signature.to_xdr(signature, <<0, 0, 0, 0>>)
    end
  end

  describe "signature type :signed_payload" do
    setup do
      raw_payload = <<1, 2, 3, 4>>
      payload = Base.encode16(raw_payload, case: :lower)
      secret = "SACHJRYLY43MUXRRCRFA6CZ5ZW5JVPPR4CWYWIX6BWRAOHOFVPVYDO5Z"
      raw_secret = KeyPair.raw_secret_seed(secret)
      hint = <<197, 134, 97, 73>>

      %{
        raw_payload: raw_payload,
        payload: payload,
        secret: secret,
        raw_secret: raw_secret,
        hint: hint,
        signature: Signature.new(signed_payload: {payload, secret})
      }
    end

    test "new/1", %{
      raw_payload: raw_payload,
      payload: payload,
      secret: secret,
      raw_secret: raw_secret,
      hint: hint
    } do
      %Signature{
        type: :signed_payload,
        key: {^payload, ^secret},
        raw_key: {^raw_payload, ^raw_secret},
        hint: ^hint
      } = Signature.new(signed_payload: {payload, secret})
    end

    test "to_xdr/1", %{signature: signature, raw_payload: raw_payload, secret: secret, hint: hint} do
      signature_xdr =
        raw_payload
        |> KeyPair.sign(secret)
        |> decorated_signature_xdr(hint)

      ^signature_xdr = Signature.to_xdr(signature)
    end

    test "to_xdr/2", %{signature: signature} do
      signature_xdr = Signature.to_xdr(signature)
      ^signature_xdr = Signature.to_xdr(signature, <<0, 0, 0, 0>>)
    end
  end
end
