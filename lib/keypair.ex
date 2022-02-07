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
  def raw_public_key(public_key), do: impl().raw_public_key(public_key)

  @impl true
  def raw_secret_seed(secret), do: impl().raw_secret_seed(secret)

  @impl true
  def sign(payload, secret), do: impl().sign(payload, secret)

  @impl true
  def validate_public_key(public_key), do: impl().validate_public_key(public_key)

  @impl true
  def validate_secret_seed(secret), do: impl().validate_secret_seed(secret)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :keypair_impl, Stellar.KeyPair.Default)
  end
end
