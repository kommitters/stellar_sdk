defmodule Stellar.Network do
  @moduledoc """
  Utility that handles Stellar's network configuration.
  """

  @passphrases [
    test: "Test SDF Network ; September 2015",
    future: "Test SDF Future Network ; October 2022",
    public: "Public Global Stellar Network ; September 2015",
    local: "Standalone Network ; February 2017"
  ]

  @public_passphrase "Public Global Stellar Network ; September 2015"
  @testnet_passphrase "Test SDF Network ; September 2015"
  @futurenet_passphrase "Test SDF Future Network ; October 2022"
  @standalone_passphrase "Standalone Network ; February 2017"

  @public_horizon_url "https://horizon.stellar.org"
  @testnet_horizon_url "https://horizon-testnet.stellar.org"
  @futurenet_horizon_url "https://horizon-futurenet.stellar.org"
  @local_horizon_url "http://localhost:8000"

  @spec public_passphrase() :: String.t()
  def public_passphrase, do: @public_passphrase

  @spec testnet_passphrase() :: String.t()
  def testnet_passphrase, do: @testnet_passphrase

  @spec futurenet_passphrase() :: String.t()
  def futurenet_passphrase, do: @futurenet_passphrase

  @spec standalone_passphrase() :: String.t()
  def standalone_passphrase, do: @standalone_passphrase

  @spec public_horizon_url() :: String.t()
  def public_horizon_url, do: @public_horizon_url

  @spec testnet_horizon_url() :: String.t()
  def testnet_horizon_url, do: @testnet_horizon_url

  @spec futurenet_horizon_url() :: String.t()
  def futurenet_horizon_url, do: @futurenet_horizon_url

  @spec local_horizon_url() :: String.t()
  def local_horizon_url, do: @local_horizon_url

  @spec passphrase() :: String.t()
  def passphrase do
    default = @passphrases[:test]
    Keyword.get(@passphrases, current(), default)
  end

  @spec current() :: atom()
  def current, do: Application.get_env(:stellar_sdk, :network, :test)
end
