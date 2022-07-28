defmodule Stellar.KeyPair do
  @moduledoc """
  Specifies an API to operate Stellar KeyPairs.

  `KeyPairs` represents public (and secret) keys of the account.
  """

  @behaviour Stellar.KeyPair.Spec

  @impl true
  def random, do: impl().random()

  @impl true
  def from_secret_seed(secret), do: impl().from_secret_seed(secret)

  @impl true
  def from_raw_public_key(raw_public_key), do: impl().from_raw_public_key(raw_public_key)

  @impl true
  def from_raw_muxed_account(raw_muxed_account),
    do: impl().from_raw_muxed_account(raw_muxed_account)

  @impl true
  def raw_public_key(public_key), do: impl().raw_public_key(public_key)

  @impl true
  def raw_muxed_account(public_key), do: impl().raw_muxed_account(public_key)

  @impl true
  def raw_secret_seed(secret), do: impl().raw_secret_seed(secret)

  @impl true
  def raw_pre_auth_tx(pre_auth_tx), do: impl().raw_pre_auth_tx(pre_auth_tx)

  @impl true
  def raw_sha256_hash(sha256_hash), do: impl().raw_sha256_hash(sha256_hash)

  @impl true
  def sign(payload, secret), do: impl().sign(payload, secret)

  @impl true
  def valid_signature?(payload, signed_payload, public_key),
    do: impl().valid_signature?(payload, signed_payload, public_key)

  @impl true
  def validate_public_key(public_key), do: impl().validate_public_key(public_key)

  @impl true
  def validate_muxed_account(public_key), do: impl().validate_muxed_account(public_key)

  @impl true
  def validate_secret_seed(secret), do: impl().validate_secret_seed(secret)

  @impl true
  def validate_pre_auth_tx(pre_auth_tx), do: impl().validate_pre_auth_tx(pre_auth_tx)

  @impl true
  def validate_sha256_hash(sha256_hash), do: impl().validate_sha256_hash(sha256_hash)

  @impl true
  def signature_hint_for_signed_payload(public_key, payload),
    do: impl().signature_hint_for_signed_payload(public_key, payload)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :keypair_impl, Stellar.KeyPair.Default)
  end
end
