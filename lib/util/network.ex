defmodule Stellar.Network do
  @moduledoc """
  Utility that handles Stellar's network configuration.
  """

  @passphrases [
    public: "Public Global Stellar Network ; September 2015",
    test: "Test SDF Network ; September 2015",
    future: "Test SDF Future Network ; October 2022",
    standalone: "Standalone Network ; February 2017"
  ]

  @horizon_urls [
    public: "https://horizon.stellar.org",
    test: "https://horizon-testnet.stellar.org",
    future: "https://horizon-futurenet.stellar.org",
    local: "http://localhost:8000"
  ]

  @spec public_passphrase() :: String.t()
  def public_passphrase, do: @passphrases[:public]

  @spec testnet_passphrase() :: String.t()
  def testnet_passphrase, do: @passphrases[:test]

  @spec futurenet_passphrase() :: String.t()
  def futurenet_passphrase, do: @passphrases[:future]

  @spec standalone_passphrase() :: String.t()
  def standalone_passphrase, do: @passphrases[:standalone]

  @spec public_horizon_url() :: String.t()
  def public_horizon_url, do: @horizon_urls[:public]

  @spec testnet_horizon_url() :: String.t()
  def testnet_horizon_url, do: @horizon_urls[:test]

  @spec futurenet_horizon_url() :: String.t()
  def futurenet_horizon_url, do: @horizon_urls[:future]

  @spec local_horizon_url() :: String.t()
  def local_horizon_url, do: @horizon_urls[:local]
end
