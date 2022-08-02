defmodule Stellar.TxBuild.SignerKeyTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.SignerKey

  setup do
    ed25519 = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    sha256_hash = "a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891"
    pre_auth_tx = "aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c"

    sha256_hash_decode = "XBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OONP"
    pre_auth_tx_decode = "TBAUEQ2EIVDEOSCJJJFUYTKOJ5IFCUSTKRAUEQ2EIVDEOSCJJJAUCYSF"

    StellarBase.StrKey.encode!(sha256_hash, :sha256_hash) |> IO.inspect()

    %{
      ed25519: ed25519,
      sha256_hash: sha256_hash,
      pre_auth_tx: pre_auth_tx,
      sha256_hash_decode: sha256_hash_decode,
      pre_auth_tx_decode: pre_auth_tx_decode,
      ed25519_signer_key_xdr: XDRFixtures.ed25519_signer_key(ed25519),
      sha256_hash_signer_key_xdr: XDRFixtures.sha256_hash_signer_key(sha256_hash),
      pre_auth_signer_key_xdr: XDRFixtures.pre_auth_signer_key(pre_auth_tx)
    }
  end

  test "new/2 ed25519", %{ed25519: ed25519} do
    %SignerKey{type: :ed25519, key: ^ed25519} = SignerKey.new({:ed25519, ed25519})
  end

  test "new/2 sha256_hash", %{sha256_hash: sha256_hash} do
    %SignerKey{type: :sha256_hash, key: ^sha256_hash} = SignerKey.new({:sha256_hash, sha256_hash})
  end

  test "new/2 pre_auth_tx", %{pre_auth_tx: pre_auth_tx} do
    %SignerKey{type: :pre_auth_tx, key: ^pre_auth_tx} = SignerKey.new({:pre_auth_tx, pre_auth_tx})
  end

  test "new/2 with_invalid_type", %{ed25519: ed25519} do
    {:error, :invalid_signer_type} = SignerKey.new({:muxed_ed25519, ed25519})
  end

  test "new/2 with_invalid_arguments", %{ed25519: ed25519} do
    {:error, :invalid_signer_key} = SignerKey.new(:ed25519, ed25519)
  end

  test "to_xdr/1 ed25519", %{ed25519_signer_key_xdr: xdr, ed25519: ed25519} do
    ^xdr =
      {:ed25519, ed25519}
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end

  test "to_xdr/1 sha256_hash", %{sha256_hash_signer_key_xdr: xdr, sha256_hash: sha256_hash} do
    ^xdr =
      {:sha256_hash, sha256_hash}
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end

  test "to_xdr/1 pre_auth_tx", %{pre_auth_signer_key_xdr: xdr, pre_auth_tx: pre_auth_tx} do
    ^xdr =
      {:pre_auth_tx, pre_auth_tx}
      |> SignerKey.new()
      |> SignerKey.to_xdr()
  end

  test "decode_key/1 ed25519", %{ed25519: ed25519} do
    %SignerKey{
      type: :ed25519,
      key: ed25519
    } =
      ed25519
      |> Base.decode32!()
      |> SignerKey.decode_key()
  end

  test "decode_key/1 sha256_hash", %{sha256_hash_decode: sha256_hash_decode} do
    %SignerKey{
      type: :sha256_hash,
      key: ^sha256_hash_decode
    } =
      sha256_hash_decode
      |> Base.decode32!()
      |> SignerKey.decode_key()
  end

  test "decode_key/1 pre_auth_tx", %{pre_auth_tx_decode: pre_auth_tx_decode} do
    %SignerKey{
      type: :pre_auth_tx,
      key: ^pre_auth_tx_decode
    } =
      pre_auth_tx_decode
      |> Base.decode32!()
      |> SignerKey.decode_key()
  end
end
