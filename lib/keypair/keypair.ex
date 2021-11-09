defmodule Stellar.KeyPair do
  @moduledoc """
  Specifies the API for processing HTTP requests in the Stellar network.
  """

  @behaviour Stellar.KeyPair.Spec

  @impl true
  def random(), do: impl().random()

  @impl true
  def from_secret(secret), do: impl().from_secret(secret)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :keypair_impl, Stellar.KeyPair.Default)
  end
end
