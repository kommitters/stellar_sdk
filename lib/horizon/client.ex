defmodule StellarSDK.Horizon.Client do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.
  Stellar allows you to use your HTTP client of choice, provided that it can be coerced into complying with this module's specification.
  The default is :hackney.
  """

  @type method :: :get | :post | :put | :delete
  @type headers :: [{binary(), binary()}, ...]
  @type options :: Keyword.t()
  @type response :: {:ok, non_neg_integer(), headers()}
  @type response_with_body :: {:ok, non_neg_integer(), headers(), binary()}
  @type response_error :: {:error, any()}

  @callback request(
              method :: method(),
              url :: binary(),
              body :: binary(),
              headers :: headers(),
              options :: options()
            ) :: response() | response_with_body() | response_error()
end
