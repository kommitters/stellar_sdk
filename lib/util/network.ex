defmodule Stellar.Network do
  @moduledoc """
  Utility that handles Stellar's network configuration.
  """

  @passphrases [
    test: "Test SDF Network ; September 2015",
    public: "Public Global Stellar Network ; September 2015"
  ]

  @base_urls [
    test: "https://horizon-testnet.stellar.org",
    public: "https://horizon.stellar.org"
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
