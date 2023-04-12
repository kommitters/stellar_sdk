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

  @base_urls [
    test: "https://horizon-testnet.stellar.org",
    future: "https://horizon-futurenet.stellar.org",
    public: "https://horizon.stellar.org",
    local: "http://localhost:8000"
  ]

  @spec base_url() :: String.t()
  def base_url do
    default = @base_urls[:test]
    Keyword.get(@base_urls, current(), default)
  end

  @spec passphrase() :: String.t()
  def passphrase do
    default = @passphrases[:test]
    Keyword.get(@passphrases, current(), default)
  end

  @spec current() :: atom()
  def current, do: Application.get_env(:stellar_sdk, :network, :test)
end
