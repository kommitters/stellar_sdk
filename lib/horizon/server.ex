defmodule Stellar.Horizon.Server do
  @moduledoc """
  Horizon Server URL configuration.
  """

  alias Stellar.Network

  @type t :: %__MODULE__{url: String.t()}

  defstruct [:url]

  @spec new(url :: String.t()) :: t()
  def new(url) when is_binary(url) do
    %__MODULE__{url: url}
  end

  @spec public() :: t()
  def public, do: new(Network.public_horizon_url())

  @spec testnet() :: t()
  def testnet, do: new(Network.testnet_horizon_url())

  @spec futurenet() :: t()
  def futurenet, do: new(Network.futurenet_horizon_url())

  @spec local() :: t()
  def local, do: new(Network.local_horizon_url())
end
