defmodule Stellar.Horizon.Client.Default do
  @moduledoc """
  Hackney HTTP client implementation.

  This implementation allows you to use your own JSON encoding library. The default is Jason.
  """

  @behaviour Stellar.Horizon.Client.Spec

  alias Stellar.Network
  alias Stellar.Horizon.Error

  @type status :: pos_integer()
  @type headers :: [{binary(), binary()}, ...]
  @type body :: binary()
  @type success_response :: {:ok, status(), headers(), body()}
  @type error_response :: {:error, status(), headers(), body()} | {:error, any()}
  @type client_response :: success_response() | error_response()
  @type parsed_response :: {:ok, map()} | {:error, Error.t()}

  @impl true
  def request(method, path, headers \\ [], body \\ "", opts \\ []) do
    base_url = Network.base_url()
    options = http_options(opts)

    method
    |> http_client().request(base_url <> path, headers, body, options)
    |> handle_response()
  end

  @spec handle_response(response :: client_response()) :: parsed_response()
  defp handle_response({:ok, status, _headers, body}) when status >= 200 and status <= 299 do
    decoded_body = json_library().decode!(body, keys: :atoms)
    {:ok, decoded_body}
  end

  defp handle_response({:ok, status, _headers, body}) when status >= 400 and status <= 599 do
    decoded_body = json_library().decode!(body, keys: :atoms)
    error = Error.new({:horizon, decoded_body})
    {:error, error}
  end

  defp handle_response({:error, reason}) do
    error = Error.new({:network, reason})
    {:error, error}
  end

  @spec http_client() :: atom()
  defp http_client, do: Application.get_env(:stellar_sdk, :http_client, :hackney)

  @spec json_library() :: module()
  defp json_library, do: Application.get_env(:stellar_sdk, :json_library, Jason)

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
