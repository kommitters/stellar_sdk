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
  def raw_public_key(public_key) do
    StrKey.decode!(public_key, :ed25519_public_key)
  end

  @impl true
  def raw_secret_seed(secret) do
    StrKey.decode!(secret, :ed25519_secret_seed)
  end

  @impl true
  def sign(<<payload::binary>>, <<secret::binary>>) do
    raw_secret = raw_secret_seed(secret)
    Ed25519.signature(payload, raw_secret)
  end

  def sign(_payload, _secret), do: {:error, :invalid_signature_payload}

  @impl true
  def validate_public_key(public_key) when byte_size(public_key) == 56 do
    case StrKey.decode(public_key, :ed25519_public_key) do
      {:ok, _key} -> :ok
      {:error, _reason} -> {:error, :invalid_ed25519_public_key}
    end
  end

  def validate_public_key(_public_key), do: {:error, :invalid_ed25519_public_key}

  @impl true
  def validate_secret_seed(secret) when byte_size(secret) == 56 do
    case StrKey.decode(secret, :ed25519_secret_seed) do
      {:ok, _secret} -> :ok
      {:error, _reason} -> {:error, :invalid_ed25519_secret_seed}
    end
  end

  def validate_secret_seed(_secret), do: {:error, :invalid_ed25519_secret_seed}
end
