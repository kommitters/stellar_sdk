defmodule Stellar.TxBuild.SignerTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{Signer, SignerKey, Weight}

  setup do
    ed25519 = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    sha256_hash = "XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC"
    pre_auth_tx = "TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B"

    signed_payload =
      "PA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAQACAQDAQCQMBYIBEFAWDANBYHRAEISCMKBKFQXDAMRUGY4DUPB6IBZGM"

    %{
      weight: Weight.new(2),
      ed25519: ed25519,
      sha256_hash: sha256_hash,
      pre_auth_tx: pre_auth_tx,
      signed_payload: signed_payload,
      ed25519_signer_key: SignerKey.new(ed25519),
      sha256_hash_signer_key: SignerKey.new(sha256_hash),
      pre_auth_tx_signer_key: SignerKey.new(pre_auth_tx),
      signed_payload_signer_key: SignerKey.new(signed_payload),
      ed25519_signer_xdr: XDRFixtures.ed25519_signer(ed25519, 2),
      sha256_hash_signer_xdr: XDRFixtures.sha256_hash_signer(sha256_hash, 2),
      pre_auth_signer_xdr: XDRFixtures.pre_auth_signer(pre_auth_tx, 2),
      signed_payload_signer_xdr: XDRFixtures.ed25519_signed_payload_signer(signed_payload, 2)
    }
  end

  test "new/2", %{ed25519: ed25519, ed25519_signer_key: signer_key, weight: weight} do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({ed25519, 2})
  end

  test "new/2 ed25519 with_input_as_keywordlist", %{
    ed25519: ed25519,
    ed25519_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new(ed25519: ed25519, weight: 2)
  end

  test "new/2 sha256_hash", %{
    sha256_hash: sha256_hash,
    sha256_hash_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({sha256_hash, 2})
  end

  test "new/2 sha256_hash with_input_as_keywordlist", %{
    sha256_hash: sha256_hash,
    sha256_hash_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} =
      Signer.new(sha256_hash: sha256_hash, weight: 2)
  end

  test "new/2 pre_auth_tx", %{
    pre_auth_tx: pre_auth_tx,
    pre_auth_tx_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({pre_auth_tx, 2})
  end

  test "new/2 pre_auth_tx with_input_as_keywordlist", %{
    pre_auth_tx: pre_auth_tx,
    pre_auth_tx_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} =
      Signer.new(pre_auth_tx: pre_auth_tx, weight: 2)
  end

  test "new/2 signed_payload", %{
    signed_payload: signed_payload,
    signed_payload_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({signed_payload, 2})
  end

  test "new/2 signed_payload with_input_as_keywordlist", %{
    signed_payload: signed_payload,
    signed_payload_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} =
      Signer.new(signed_payload: signed_payload, weight: 2)
  end

  test "new/2 with_invalid_signer_key" do
    {:error, :invalid_signer_key} = Signer.new({"XCTP2Y5GZ7TTGHLM3JJKDIPR36", 2})
  end

  test "new/2 with_invalid_signer_weight", %{ed25519: ed25519} do
    {:error, :invalid_signer_weight} = Signer.new({ed25519, 256})
  end

  test "new/2 with_invalid_arguments", %{ed25519: ed25519} do
    {:error, :invalid_signer} = Signer.new({ed25519})
  end

  test "to_xdr/1", %{ed25519_signer_xdr: xdr, ed25519: ed25519} do
    ^xdr =
      {ed25519, 2}
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 sha256_hash", %{sha256_hash_signer_xdr: xdr, sha256_hash: sha256_hash} do
    ^xdr =
      {sha256_hash, 2}
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 pre_auth_tx", %{pre_auth_signer_xdr: xdr, pre_auth_tx: pre_auth_tx} do
    ^xdr =
      {pre_auth_tx, 2}
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 signed_payload", %{
    signed_payload_signer_xdr: xdr,
    signed_payload: signed_payload
  } do
    ^xdr =
      {signed_payload, 2}
      |> Signer.new()
      |> Signer.to_xdr()
  end
end
