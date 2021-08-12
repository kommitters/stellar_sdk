defmodule StellarSDK.Horizon.Client do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.
  Stellar allows you to use your HTTP client of choice, provided that it can be coerced into complying with this module's specification.
  The default is :hackney.
  """

  @type http_method :: :get | :post | :put | :delete
  @type response :: {:ok, %{status_code: pos_integer, headers: any}}
  @type response_with_body :: {:ok, %{status_code: pos_integer, headers: any, body: binary}}
  @type response_error :: {:error, %{reason: any}}

  @callback request(
              method :: http_method,
              url :: binary,
              req_body :: binary,
              headers :: [{binary, binary}, ...],
              http_opts :: any
            ) :: response | response_with_body | response_error
end
