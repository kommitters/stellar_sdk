defmodule StellarSDK.Horizon.Hackney do
  @moduledoc """
  HTTP client for `:hackney`
  Options can be set for `:hackney` with the following config:
  ```
    config :stellar, :hackney_opts,
      recv_timeout: 30_000
  ```
  """

  @behaviour StellarSDK.Horizon.Client

  @default_options [recv_timeout: 30_000, follow_redirect: true]

  @impl true
  def request(method, url, body, headers, http_opts) do
    case :hackney.request(method, url, headers, body, options(http_opts)) do
      {:ok, status, headers} ->
        {:ok, %{status_code: status, headers: headers}}

      {:ok, status, headers, body} ->
        {:ok, %{status_code: status, headers: headers, body: body}}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  @spec options(Keyword.t()) :: Keyword.t()
  defp options(options) do
    config_options = Application.get_env(:stellar_sdk, :hackney_options, [])

    @default_options
    |> Keyword.merge(config_options)
    |> Keyword.merge(options)
    |> (&[:with_body | &1]).()
  end
end
