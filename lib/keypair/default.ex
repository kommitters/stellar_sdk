defmodule Stellar.KeyPair.Default do
  @moduledoc """
  Ed25519 functions to manage signatures.
  """
  alias StellarBase.StrKey

  @behaviour Stellar.KeyPair.Spec

  @impl true
  def random do
    {secret, public_key} = Ed25519.generate_key_pair()
    encoded_public_key = StrKey.encode!(public_key, :ed25519_public_key)
    encoded_secret = StrKey.encode!(secret, :ed25519_secret_seed)

    {encoded_public_key, encoded_secret}
  end

  @impl true
  def from_secret_seed(secret) do
    public_key =
      secret
      |> StrKey.decode!(:ed25519_secret_seed)
      |> Ed25519.derive_public_key()
      |> StrKey.encode!(:ed25519_public_key)

    {public_key, secret}
  end

  @impl true
  def from_raw_public_key(public_key) do
    StrKey.encode!(public_key, :ed25519_public_key)
  end

  @impl true
  def from_raw_muxed_account(muxed_account) do
    StrKey.encode!(muxed_account, :muxed_account)
  end

  @impl true
  def raw_public_key(public_key) do
    StrKey.decode!(public_key, :ed25519_public_key)
  end

  @impl true
  def raw_secret_seed(secret) do
    StrKey.decode!(secret, :ed25519_secret_seed)
  end

  @impl true
  def raw_muxed_account(muxed_account) do
    StrKey.decode!(muxed_account, :muxed_account)
  end

  @impl true
  def raw_pre_auth_tx(pre_auth_tx) do
    StrKey.decode!(pre_auth_tx, :pre_auth_tx)
  end

  @impl true
  def raw_sha256_hash(sha256_hash) do
    StrKey.decode!(sha256_hash, :sha256_hash)
  end

  @impl true
  def sign(<<payload::binary>>, <<secret::binary>>) do
    raw_secret = raw_secret_seed(secret)
    Ed25519.signature(payload, raw_secret)
  end

  def sign(_payload, _secret), do: {:error, :invalid_signature_payload}

  @impl true
  def valid_signature?(<<payload::binary>>, <<signed_payload::binary>>, <<public_key::binary>>) do
    raw_public_key = raw_public_key(public_key)
    Ed25519.valid_signature?(signed_payload, payload, raw_public_key)
  end

  def valid_signature?(_payload, _signed_payload, _public_key), do: false

  @impl true
  def validate_public_key(public_key) do
    case StrKey.decode(public_key, :ed25519_public_key) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_ed25519_public_key}
    end
  end

  @impl true
  def validate_muxed_account(muxed_account) do
    case StrKey.decode(muxed_account, :muxed_account) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_ed25519_muxed_account}
    end
  end

  @impl true
  def validate_secret_seed(secret) do
    case StrKey.decode(secret, :ed25519_secret_seed) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_ed25519_secret_seed}
    end
  end

  @impl true
  def validate_pre_auth_tx(pre_auth_tx) do
    case StrKey.decode(pre_auth_tx, :pre_auth_tx) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_pre_auth_tx}
    end
  end

  @impl true
  def validate_sha256_hash(sha256_hash) do
    case StrKey.decode(sha256_hash, :sha256_hash) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_sha256_hash}
    end

  @impl true
  def signature_hint_for_signed_payload(
        <<last_public_key_bytes::binary-size(4), _public_key::binary>>,
        <<last_payload_bytes::binary-size(4), _payload::binary>>
      ) do
    :crypto.exor(last_public_key_bytes, last_payload_bytes)
  end

  def signature_hint_for_signed_payload(
        <<last_public_key_bytes::binary-size(4), _public_key::binary>>,
        raw_payload
      ) do
    raw_payload
    |> byte_size()
    |> (&(:binary.copy(<<0>>, 4 - &1) <> raw_payload)).()
    |> (&:crypto.exor(last_public_key_bytes, &1)).()
  end
end
