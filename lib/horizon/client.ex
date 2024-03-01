defmodule Stellar.Horizon.Client do
  @moduledoc """
  Specifies the API for processing HTTP requests in the Stellar network.
  """
  alias Stellar.Horizon.Client

  @behaviour Client.Spec

  @impl true
  def request(server, method, path, headers \\ [], body \\ "", opts \\ []),
    do: impl().request(server, method, path, headers, body, opts)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:stellar_sdk, :http_client_impl, Client.Default)
  end
end
