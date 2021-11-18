defmodule Stellar.KeyPair do
  @moduledoc """
  Specifies the API for processing HTTP requests in the Stellar network.
  """

  @behaviour Stellar.KeyPair.Spec

  @impl true
  def random, do: impl().random()

  @impl true
  def from_secret(secret), do: impl().from_secret(secret)

  @impl true
  def raw_ed25519_public_key(public_key), do: impl().raw_ed25519_public_key(public_key)

  @impl true
  def raw_ed25519_secret(secret), do: impl().raw_ed25519_secret(secret)

  @impl true
  def sign(payload, secret), do: impl().sign(payload, secret)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :keypair_impl, Stellar.KeyPair.Default)
  end
end
