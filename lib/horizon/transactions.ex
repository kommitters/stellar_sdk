defmodule Stellar.Horizon.Transactions do
  @moduledoc """
  Exposes functions to interact with Transactions in Horizon.

  You can:
  - Create a transaction.

  Horizon API reference: https://developers.stellar.org/api/resources/transactions/
  """

  alias Stellar.Horizon.{Error, Transaction}
  alias Stellar.Horizon.Client, as: Horizon

  @type response :: {:ok, Transaction.t()} | {:error, Error.t()}

  @endpoint "/transactions/"

  @spec create(base64_envelope :: String.t()) :: response()
  def create(base64_envelope) do
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    body = URI.encode_query(tx: base64_envelope)

    case Horizon.request(:post, @endpoint, headers, body) do
      {:ok, tx} -> {:ok, Transaction.new(tx)}
      error -> error
    end
  end
end