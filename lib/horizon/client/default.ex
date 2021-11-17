defmodule Stellar.Horizon.Client.Default do
  @moduledoc """
  Hackney HTTP client implementation.
  """
  alias Stellar.Network

  @behaviour Stellar.Horizon.Client.Spec

  @impl true
  def request(method, path, headers \\ [], body \\ "", opts \\ []) do
    base_url = Network.base_url()
    options = http_options(opts)

    http_client().request(method, base_url <> path, headers, body, options)
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
end
