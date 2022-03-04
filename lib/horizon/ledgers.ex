defmodule Stellar.Horizon.Ledgers do
  @moduledoc """
  Exposes functions to interact with Ledgers in Horizon.

  You can:
  * Retrieve a ledger.
  * List all ledgers.
  * List a ledger's effects.
  * List a ledger's transactions.
  * List a ledger's operations.

  Horizon API reference: https://developers.stellar.org/api/resources/ledgers/
  """

  alias Stellar.Horizon.{
    Collection,
    Effect,
    Error,
    Ledger,
    Operation,
    Request,
    Transaction
  }

  @type sequence :: non_neg_integer()
  @type params :: Keyword.t()
  @type resource :: Ledger.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "ledgers"

  @spec retrieve(sequence :: sequence()) :: response()
  def retrieve(sequence) do
    :get
    |> Request.new(@endpoint, path: sequence)
    |> Request.perform()
    |> Request.results(&Ledger.new(&1))
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Ledger, &1}))
  end

  @spec list_transactions(sequence :: sequence(), params :: params()) :: response()
  def list_transactions(sequence, params \\ []) do
    :get
    |> Request.new(@endpoint, path: sequence, segment: "transactions")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Transaction, &1}))
  end

  @spec list_operations(sequence :: sequence(), params :: params()) :: response()
  def list_operations(sequence, params \\ []) do
    :get
    |> Request.new(@endpoint, path: sequence, segment: "operations")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec list_payments(sequence :: sequence(), params :: params()) :: response()
  def list_payments(sequence, params \\ []) do
    :get
    |> Request.new(@endpoint, path: sequence, segment: "payments")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec list_effects(sequence :: sequence(), params :: params()) :: response()
  def list_effects(sequence, params \\ []) do
    :get
    |> Request.new(@endpoint, path: sequence, segment: "effects")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Effect, &1}))
  end
end
