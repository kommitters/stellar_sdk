defmodule Stellar.TxBuild.SignerTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{Signer, SignerKey, Weight}

  setup do
    ed25519 = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    sha256_hash = "a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891"
    pre_auth_tx = "aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c"

    %{
      weight: Weight.new(2),
      ed25519: ed25519,
      sha256_hash: sha256_hash,
      pre_auth_tx: pre_auth_tx,
      ed25519_signer_key: SignerKey.new({:ed25519, ed25519}),
      sha256_hash_signer_key: SignerKey.new({:sha256_hash, sha256_hash}),
      pre_auth_tx_signer_key: SignerKey.new({:pre_auth_tx, pre_auth_tx}),
      ed25519_signer_xdr: XDRFixtures.ed25519_signer(ed25519, 2),
      sha256_hash_signer_xdr: XDRFixtures.sha256_hash_signer(sha256_hash, 2),
      pre_auth_signer_xdr: XDRFixtures.pre_auth_signer(pre_auth_tx, 2)
    }
  end

  test "new/2", %{ed25519: ed25519, ed25519_signer_key: signer_key, weight: weight} do
    %Signer{signer_key: ^signer_key, weight: ^weight} = Signer.new(ed25519: ed25519, weight: 2)
  end

  test "new/2 sha256_hash", %{
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
    %Signer{signer_key: ^signer_key, weight: ^weight} =
      Signer.new(pre_auth_tx: pre_auth_tx, weight: 2)
  end

  test "new/2 with_invalid_signer_key", %{ed25519: ed25519} do
    {:error, :invalid_signer_key} = Signer.new(muxed_ed25519: ed25519, weight: 2)
  end

  test "new/2 with_invalid_signer_weight", %{ed25519: ed25519} do
    {:error, :invalid_signer_weight} = Signer.new(ed25519: ed25519, weight: 256)
  end

  test "new/2 with_invalid_arguments", %{ed25519: ed25519} do
    {:error, :invalid_signer} = Signer.new(:ed25519, ed25519)
  end

  test "to_xdr/1", %{ed25519_signer_xdr: xdr, ed25519: ed25519} do
    ^xdr =
      [ed25519: ed25519, weight: 2]
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 sha256_hash", %{sha256_hash_signer_xdr: xdr, sha256_hash: sha256_hash} do
    ^xdr =
      [sha256_hash: sha256_hash, weight: 2]
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 pre_auth_tx", %{pre_auth_signer_xdr: xdr, pre_auth_tx: pre_auth_tx} do
    ^xdr =
      [pre_auth_tx: pre_auth_tx, weight: 2]
      |> Signer.new()
      |> Signer.to_xdr()
  end
end
