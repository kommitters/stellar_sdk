defmodule StellarSDK.Horizon do
  @moduledoc false

  @behaviour StellarSDK.Horizon.Client

  @impl true
  def request(method, path, headers \\ [], body \\ "", opts \\ []) do
    base_url = config()[:url]
    options = http_options(opts)

    http_client().request(method, base_url <> path, headers, body, options)
  end

  @spec config() :: Keyword.t()
  def config do
    network = Application.get_env(:stellar_sdk, :network, :test)

    [
      network: network,
      url: network_url(network),
      passphrase: network_passphrase(network)
    ]
  end

  @spec http_client() :: atom()
  defp http_client, do: Application.get_env(:stellar_sdk, :http_client, :hackney)

  @spec http_options(options :: Keyword.t()) :: Keyword.t()
  defp http_options(options) do
    default_options = [recv_timeout: 30_000, follow_redirect: true]
    override_options = Application.get_env(:stellar_sdk, :hackney_options, [])

    default_options
    |> Keyword.merge(override_options)
    |> Keyword.merge(options)
    |> (&[:with_body | &1]).()
  end

  @spec network_url(network :: atom) :: String.t()
  defp network_url(:public), do: "https://horizon.stellar.org"
  defp network_url(_network), do: "https://horizon-testnet.stellar.org"

  @spec network_passphrase(network :: atom) :: String.t()
  defp network_passphrase(:public), do: "Public Global Stellar Network ; September 2015"
  defp network_passphrase(_network), do: "Test SDF Network ; September 2015"
end
