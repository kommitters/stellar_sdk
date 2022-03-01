defmodule Stellar.Horizon.Transactions do
  @moduledoc """
  Exposes functions to interact with Transactions in Horizon.

  You can:
  * Create a transaction.
  * Retrieve a transaction.
  * List all transactions.
  * List a transaction's effects.
  * List a transaction's operations.

  Horizon API reference: https://developers.stellar.org/api/resources/transactions/
  """

  alias Stellar.Horizon.{Collection, Effect, Error, Operation, Transaction, Request}

  @type hash :: String.t()
  @type params :: Keyword.t()
  @type resource :: Transaction.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "transactions"

  @spec create(base64_envelope :: String.t()) :: response()
  def create(base64_envelope) do
    :post
    |> Request.new(@endpoint)
    |> Request.add_headers([{"Content-Type", "application/x-www-form-urlencoded"}])
    |> Request.add_body(tx: base64_envelope)
    |> Request.perform()
    |> Request.results(&Transaction.new(&1))
  end

  @spec retrieve(hash :: hash()) :: response()
  def retrieve(hash) do
    :get
    |> Request.new(@endpoint, path: hash)
    |> Request.perform()
    |> Request.results(&Transaction.new(&1))
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Transaction, &1}))
  end

  @spec list_effects(hash :: hash(), params :: params()) :: response()
  def list_effects(hash, params \\ []) do
    :get
    |> Request.new(@endpoint, path: hash, segment: "effects")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Effect, &1}))
  end

  @spec list_operations(hash :: hash(), params :: params()) :: response()
  def list_operations(hash, params \\ []) do
    :get
    |> Request.new(@endpoint, path: hash, segment: "operations")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end
end
