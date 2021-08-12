defmodule StellarSDK.Horizon do
  @moduledoc false

  @behaviour StellarSDK.Horizon.Client

  @impl true
  def request(method, path, body \\ "", headers \\ [], http_opts \\ []) do
    base_url = network_config(:url)
    http_client().request(method, base_url <> path, body, headers, http_opts)
  end

  @spec network_config(atom) :: String.t()
  def network_config(key), do: Keyword.get(network_config(), key)

  @spec network_config :: Keyword.t()
  def network_config do
    network = Application.get_env(:stellar_sdk, :network, :public)

    [
      network: network,
      url: network_url(network),
      passphrase: network_passphrase(network)
    ]
  end

  @spec http_client :: atom
  defp http_client do
    Application.get_env(:stellar_sdk, :http_client, StellarSDK.Horizon.Hackney)
  end

  @spec network_url(network :: atom) :: String.t()
  defp network_url(:public), do: "https://horizon.stellar.org"
  defp network_url(_network), do: "https://horizon-testnet.stellar.org"

  @spec network_passphrase(network :: atom) :: String.t()
  defp network_passphrase(:public), do: "Public Global Stellar Network ; September 2015"
  defp network_passphrase(_network), do: "Test SDF Network ; September 2015"
end
