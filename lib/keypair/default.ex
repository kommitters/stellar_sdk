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
end
