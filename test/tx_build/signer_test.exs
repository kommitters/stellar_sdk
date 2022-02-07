defmodule Stellar.TxBuild.SignerTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [signer_xdr: 1]

  alias Stellar.TxBuild.{Signer, Weight}

  setup do
    ed25519_key = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    sha256_hash_key = "a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891"
    pre_auth_tx_key = "aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c"

    %{
      weight: Weight.new(2),
      ed25519_key: ed25519_key,
      sha256_hash_key: sha256_hash_key,
      pre_auth_tx_key: pre_auth_tx_key,
      ed25519_signer_xdr: signer_xdr(ed25519: ed25519_key, weight: 2),
      sha256_hash_signer_xdr: signer_xdr(sha256_hash: sha256_hash_key, weight: 2),
      pre_auth_signer_xdr: signer_xdr(pre_auth_tx: pre_auth_tx_key, weight: 2)
    }
  end

  test "new/2", %{ed25519_key: ed25519_key, weight: weight} do
    %Signer{type: :ed25519, key: ^ed25519_key, weight: ^weight} =
      Signer.new(ed25519: ed25519_key, weight: 2)
  end

  test "new/2 with_tuple_arguments", %{ed25519_key: ed25519_key, weight: weight} do
    %Signer{type: :ed25519, key: ^ed25519_key, weight: ^weight} =
      Signer.new([{:ed25519, ed25519_key}, {:weight, 2}])
  end

  test "new/2 sha256_hash", %{sha256_hash_key: sha256_hash_key, weight: weight} do
    %Signer{type: :sha256_hash, key: ^sha256_hash_key, weight: ^weight} =
      Signer.new(sha256_hash: sha256_hash_key, weight: 2)
  end

  test "new/2 pre_auth_tx", %{pre_auth_tx_key: pre_auth_tx_key, weight: weight} do
    %Signer{type: :pre_auth_tx, key: ^pre_auth_tx_key, weight: ^weight} =
      Signer.new(pre_auth_tx: pre_auth_tx_key, weight: 2)
  end

  test "new/2 with_invalid_signer_key", %{ed25519_key: ed25519_key} do
    {:error, :invalid_signer_type} = Signer.new(muxed_ed25519: ed25519_key, weight: 2)
  end

  test "new/2 with_invalid_signer_weight", %{ed25519_key: ed25519_key} do
    {:error, :invalid_signer_weight} = Signer.new(ed25519: ed25519_key, weight: 256)
  end

  test "new/2 with_invalid_arguments", %{ed25519_key: ed25519_key} do
    {:error, :invalid_signer} = Signer.new(:ed25519, ed25519_key)
  end

  test "to_xdr/1", %{ed25519_signer_xdr: xdr, ed25519_key: ed25519_key} do
    ^xdr =
      [ed25519: ed25519_key, weight: 2]
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 sha256_hash", %{sha256_hash_signer_xdr: xdr, sha256_hash_key: sha256_hash_key} do
    ^xdr =
      [sha256_hash: sha256_hash_key, weight: 2]
      |> Signer.new()
      |> Signer.to_xdr()
  end

  test "to_xdr/1 pre_auth_tx_key", %{pre_auth_signer_xdr: xdr, pre_auth_tx_key: pre_auth_tx_key} do
    ^xdr =
      [pre_auth_tx: pre_auth_tx_key, weight: 2]
      |> Signer.new()
      |> Signer.to_xdr()
  end
end
