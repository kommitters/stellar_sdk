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
  def raw_signed_payload(signed_payload) do
    StrKey.decode!(signed_payload, :signed_payload)
  end

  @impl true
  def raw_contract(contract) do
    StrKey.decode!(contract, :contract)
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
  def validate_signed_payload(signed_payload) do
    case StrKey.decode(signed_payload, :signed_payload) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_signed_payload}
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
  end

  @impl true
  def validate_contract(contract) do
    case StrKey.decode(contract, :contract) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_contract}
    end
  end

  @impl true
  def signature_hint_for_signed_payload(public_key, payload) when byte_size(payload) < 4 do
    zeros_needed = 4 - byte_size(payload)
    signature_hint_for_signed_payload(public_key, <<payload::binary, 0::zeros_needed*8>>)
  end

  def signature_hint_for_signed_payload(public_key, payload) do
    hint = last_bytes(public_key)
    payload = last_bytes(payload)
    :crypto.exor(hint, payload)
  end

  @spec last_bytes(data :: binary()) :: binary()
  defp last_bytes(data) do
    bytes_size = byte_size(data)
    binary_part(data, bytes_size, -4)
  end
end
