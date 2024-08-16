defmodule Stellar.Horizon.ErrorMapper do
  @moduledoc """
  Assigns errors returned by the HTTP client to a custom structure.
  """
  alias Stellar.Horizon.AsyncTransactionError
  alias Stellar.Horizon.AsyncTransaction
  alias Stellar.Horizon.Error

  @type error_source :: :horizon | :network
  @type error_body :: map() | atom() | String.t()
  @type error :: {error_source(), error_body()}

  @type t :: {:error, struct()}

  @spec build(error :: error()) :: t()
  def build(
        {:horizon,
         %{hash: _hash, errorResultXdr: _error_result_xdr, tx_status: _tx_status} = decoded_body}
      ) do
    error = AsyncTransactionError.new(decoded_body)
    {:error, error}
  end

  def build({:horizon, %{hash: _hash, tx_status: _tx_status} = decoded_body}) do
    error = AsyncTransaction.new(decoded_body)
    {:error, error}
  end

  def build(error), do: {:error, Error.new(error)}
end
