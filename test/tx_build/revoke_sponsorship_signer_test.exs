defmodule Stellar.TxBuild.RevokeSponsorshipSignerTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{RevokeSponsorshipSigner, SignerKey, AccountID}

  setup do
    account_id = "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35"
    ed25519 = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    sha256_hash = "a6fd63a6cfe7331d6cda52a1a1f1df81f814b6e5709ad3d06f18d414a801b891"
    pre_auth_tx = "aa5326cd097eb68afc3b49381fe6be297a2322a4c59ebef49676a4d892adda2c"

    %{
      account_id: account_id,
      ed25519: ed25519,
      sha256_hash: sha256_hash,
      pre_auth_tx: pre_auth_tx,
      ed25519_signer_key: SignerKey.new({:ed25519, ed25519}),
      sha256_hash_signer_key: SignerKey.new({:sha256_hash, sha256_hash}),
      pre_auth_tx_signer_key: SignerKey.new({:pre_auth_tx, pre_auth_tx}),
      ed25519_signer_xdr: XDRFixtures.ed25519_revoke_sponsorship_signer(account_id, ed25519),
      sha256_hash_signer_xdr:
        XDRFixtures.sha256_hash_revoke_sponsorship_signer(account_id, sha256_hash),
      pre_auth_signer_xdr: XDRFixtures.pre_auth_revoke_sponsorship_signer(account_id, pre_auth_tx)
    }
  end

  test "new/2 ed25519", %{
    account_id: account_id,
    ed25519: ed25519,
    ed25519_signer_key: signer_key
  } do
    %RevokeSponsorshipSigner{
      account_id: %AccountID{account_id: ^account_id},
      signer_key: ^signer_key
    } = RevokeSponsorshipSigner.new(account_id: account_id, ed25519: ed25519)
  end

  test "new/2 sha256_hash", %{
    account_id: account_id,
    sha256_hash: sha256_hash,
    sha256_hash_signer_key: signer_key
  } do
    %RevokeSponsorshipSigner{
      account_id: %AccountID{account_id: ^account_id},
      signer_key: ^signer_key
    } = RevokeSponsorshipSigner.new(account_id: account_id, sha256_hash: sha256_hash)
  end

  test "new/2 pre_auth_tx", %{
    account_id: account_id,
    pre_auth_tx: pre_auth_tx,
    pre_auth_tx_signer_key: signer_key
  } do
    %RevokeSponsorshipSigner{
      account_id: %AccountID{account_id: ^account_id},
      signer_key: ^signer_key
    } = RevokeSponsorshipSigner.new(account_id: account_id, pre_auth_tx: pre_auth_tx)
  end

  test "new/2 with_invalid_signer_key", %{account_id: account_id, ed25519: ed25519} do
    {:error, :invalid_signer_key} =
      RevokeSponsorshipSigner.new(account_id: account_id, muxed_ed25519: ed25519)
  end

  test "new/2 with_invalid_account_id", %{ed25519: ed25519} do
    {:error, :invalid_account_id} =
      RevokeSponsorshipSigner.new(account_id: "ABCD", ed25519: ed25519)
  end

  test "new/2 with_invalid_arguments", %{ed25519: ed25519} do
    {:error, :invalid_sponsorship_signer} = RevokeSponsorshipSigner.new(:ed25519, ed25519)
  end

  test "to_xdr/1", %{account_id: account_id, ed25519_signer_xdr: xdr, ed25519: ed25519} do
    ^xdr =
      [account_id: account_id, ed25519: ed25519]
      |> RevokeSponsorshipSigner.new()
      |> RevokeSponsorshipSigner.to_xdr()
  end

  test "to_xdr/1 sha256_hash", %{
    account_id: account_id,
    sha256_hash_signer_xdr: xdr,
    sha256_hash: sha256_hash
  } do
    ^xdr =
      [account_id: account_id, sha256_hash: sha256_hash]
      |> RevokeSponsorshipSigner.new()
      |> RevokeSponsorshipSigner.to_xdr()
  end

  test "to_xdr/1 pre_auth_tx", %{
    account_id: account_id,
    pre_auth_signer_xdr: xdr,
    pre_auth_tx: pre_auth_tx
  } do
    ^xdr =
      [account_id: account_id, pre_auth_tx: pre_auth_tx]
      |> RevokeSponsorshipSigner.new()
      |> RevokeSponsorshipSigner.to_xdr()
  end
end
