defmodule Stellar.Horizon.Client.Spec do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.

  Stellar allows you to use your HTTP client of choice, provided that it can be coerced into complying with this module's specification.
  The default is :hackney.
  """

  @type server :: Stellar.Horizon.Server.t()
  @type method :: :get | :post | :put | :delete
  @type headers :: [{binary(), binary()}, ...]
  @type body :: binary()
  @type status :: non_neg_integer()
  @type options :: Keyword.t()
  @type response :: {:ok, status(), headers()}
  @type response_with_body :: {:ok, status(), headers(), body()}
  @type response_error :: {:error, any()}

  @callback request(
              server :: server(),
              method :: method(),
              url :: binary(),
              body :: binary(),
              headers :: headers(),
              options :: options()
            ) :: response() | response_with_body() | response_error()
end
