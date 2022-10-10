defmodule Stellar.TxBuild.SignerTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{Signer, SignerKey, Weight}

  setup do
    ed25519 = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    hash_x = "XCTP2Y5GZ7TTGHLM3JJKDIPR36A7QFFW4VYJVU6QN4MNIFFIAG4JC6CC"
    pre_auth_tx = "TCVFGJWNBF7LNCX4HNETQH7GXYUXUIZCUTCZ5PXUSZ3KJWESVXNCYN3B"

    signed_payload =
      "PA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAQACAQDAQCQMBYIBEFAWDANBYHRAEISCMKBKFQXDAMRUGY4DUPB6IBZGM"

    hex_hash_x = "a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891"
    hex_pre_auth_tx = "aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c"

    signed_payload_opts = [
      ed25519: "GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ",
      payload: "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"
    ]

    %{
      weight: Weight.new(2),
      ed25519: ed25519,
      hash_x: hash_x,
      pre_auth_tx: pre_auth_tx,
      signed_payload: signed_payload,
      hex_hash_x: hex_hash_x,
      hex_pre_auth_tx: hex_pre_auth_tx,
      signed_payload_opts: signed_payload_opts,
      ed25519_signer_key: SignerKey.new(ed25519),
      hash_x_signer_key: SignerKey.new(hash_x),
      pre_auth_tx_signer_key: SignerKey.new(pre_auth_tx),
      signed_payload_signer_key: SignerKey.new(signed_payload),
      ed25519_signer_xdr: XDRFixtures.ed25519_signer(ed25519, 2),
      hash_x_signer_xdr: XDRFixtures.sha256_hash_signer(hash_x, 2),
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

  test "new/2 hash_x", %{
    hash_x: hash_x,
    hash_x_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({hash_x, 2})
  end

  test "new/2 hash_x with_input_as_keywordlist", %{
    hex_hash_x: hex_hash_x,
    hash_x_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new(hash_x: hex_hash_x, weight: 2)
  end

  test "new/2 pre_auth_tx", %{
    pre_auth_tx: pre_auth_tx,
    pre_auth_tx_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({pre_auth_tx, 2})
  end

  test "new/2 pre_auth_tx with_input_as_keywordlist", %{
    hex_pre_auth_tx: hex_pre_auth_tx,
    pre_auth_tx_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} =
      Signer.new(pre_auth_tx: hex_pre_auth_tx, weight: 2)
  end

  test "new/2 signed_payload", %{
    signed_payload: signed_payload,
    signed_payload_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new({signed_payload, 2})
  end

  test "new/2 signed_payload with_input_as_keywordlist", %{
    signed_payload_opts: signed_payload_opts,
    signed_payload_signer_key: signer_key,
    weight: weight
  } do
    %Signer{signer_key: ^signer_key, weight: ^weight} =
      Signer.new(signed_payload: signed_payload_opts, weight: 2)
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

  test "to_xdr/1 hash_x", %{hash_x_signer_xdr: xdr, hash_x: hash_x} do
    ^xdr =
      {hash_x, 2}
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
