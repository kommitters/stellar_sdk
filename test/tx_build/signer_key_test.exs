defmodule Stellar.TxBuild.SignerKeyTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.SignerKey

  setup do
    ed25519 = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    sha256_hash = "XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC"
    pre_auth_tx = "TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B"
    payload = "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"

    %{
      ed25519: ed25519,
      sha256_hash: sha256_hash,
      pre_auth_tx: pre_auth_tx,
      payload: payload,
      ed25519_signer_key_xdr: XDRFixtures.ed25519_signer_key(ed25519),
      sha256_hash_signer_key_xdr: XDRFixtures.sha256_hash_signer_key(sha256_hash),
      pre_auth_signer_key_xdr: XDRFixtures.pre_auth_signer_key(pre_auth_tx),
      ed25519_signed_payload_xdr: XDRFixtures.ed25519_signed_payload(ed25519, payload)
    }
  end

  test "new/2 ed25519", %{ed25519: ed25519} do
    %SignerKey{type: :ed25519, key: ^ed25519} = SignerKey.new(ed25519)
  end

  test "new/2 sha256_hash", %{sha256_hash: sha256_hash} do
    %SignerKey{type: :sha256_hash, key: ^sha256_hash} = SignerKey.new(sha256_hash)
  end

  test "new/2 pre_auth_tx", %{pre_auth_tx: pre_auth_tx} do
    %SignerKey{type: :pre_auth_tx, key: ^pre_auth_tx} = SignerKey.new(pre_auth_tx)
  end

  test "new/2 ed25519_signed_payload", %{ed25519: ed25519, payload: payload} do
    %SignerKey{type: :ed25519_signed_payload, key: {^ed25519, ^payload}} =
      SignerKey.new({:ed25519_signed_payload, {ed25519, payload}})
  end

  test "new/2 with_invalid_type" do
    {:error, :invalid_signer_type} = SignerKey.new("CFTGHYSDSSDDSRRSS")
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_signer_key} = SignerKey.new("XCTP2Y5GZ7TTGHLM3JJKDIPR36")
  end

  test "to_xdr/1 ed25519", %{ed25519_signer_key_xdr: xdr, ed25519: ed25519} do
    ^xdr =
      ed25519
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end

  test "to_xdr/1 sha256_hash", %{sha256_hash_signer_key_xdr: xdr, sha256_hash: sha256_hash} do
    ^xdr =
      sha256_hash
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end

  test "to_xdr/1 pre_auth_tx", %{pre_auth_signer_key_xdr: xdr, pre_auth_tx: pre_auth_tx} do
    ^xdr =
      pre_auth_tx
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end

  test "to_xdr/1 signed_payload", %{
    ed25519_signed_payload_xdr: xdr,
    ed25519: ed25519,
    payload: payload
  } do
    ^xdr =
      {:ed25519_signed_payload, {ed25519, payload}}
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end
end
