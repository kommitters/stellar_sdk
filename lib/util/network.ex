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

  @type passphrase :: String.t()
  @type url :: String.t()
  @type hash :: String.t()

  @spec public_passphrase() :: passphrase()
  def public_passphrase, do: @passphrases[:public]

  @spec testnet_passphrase() :: passphrase()
  def testnet_passphrase, do: @passphrases[:test]

  @spec futurenet_passphrase() :: passphrase()
  def futurenet_passphrase, do: @passphrases[:future]

  @spec standalone_passphrase() :: passphrase()
  def standalone_passphrase, do: @passphrases[:standalone]

  @spec public_horizon_url() :: url()
  def public_horizon_url, do: @horizon_urls[:public]

  @spec testnet_horizon_url() :: url()
  def testnet_horizon_url, do: @horizon_urls[:test]

  @spec futurenet_horizon_url() :: url()
  def futurenet_horizon_url, do: @horizon_urls[:future]

  @spec local_horizon_url() :: url()
  def local_horizon_url, do: @horizon_urls[:local]

  @spec network_id(passphrase :: passphrase()) :: hash()
  def network_id(passphrase), do: :crypto.hash(:sha256, passphrase)
end
