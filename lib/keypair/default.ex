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
  def from_secret(secret) do
    public_key =
      secret
      |> StrKey.decode!(:ed25519_secret_seed)
      |> Ed25519.derive_public_key()
      |> StrKey.encode!(:ed25519_public_key)

    {public_key, secret}
  end

  @impl true
  def raw_ed25519_public_key(public_key) do
    StrKey.decode!(public_key, :ed25519_public_key)
  end

  @impl true
  def raw_ed25519_secret(secret) do
    StrKey.decode!(secret, :ed25519_secret_seed)
  end

  @impl true
  def sign(<<payload::binary>>, <<secret::binary>>) do
    raw_secret = raw_ed25519_secret(secret)
    Ed25519.signature(payload, raw_secret)
  end

  def sign(_payload, _secret), do: {:error, :invalid_signature_payload}
end
