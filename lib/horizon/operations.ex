defmodule Stellar.Horizon.Operations do
  @moduledoc """
  Exposes functions to interact with Operations in Horizon.

  You can:
  * Retrieve an operation.
  * List all operations.
  * List operation's effects.
  * List all payments.

  Horizon API reference: https://developers.stellar.org/api/resources/operations/
  """

  alias Stellar.Horizon.{Collection, Effect, Error, Operation, Request}

  @type operation_id :: String.t()
  @type params :: Keyword.t()
  @type resource :: Operation.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "operations"
  @payments_endpoint "payments"

  @spec retrieve(operation_id :: operation_id(), params :: params()) :: response()
  def retrieve(operation_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: operation_id)
    |> Request.add_query(params, extra_params: [:join])
    |> Request.perform()
    |> Request.results(&Operation.new(&1))
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec all_payments(params :: params()) :: response()
  def all_payments(params \\ []) do
    :get
    |> Request.new(@payments_endpoint)
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec list_effects(operation_id :: operation_id(), params :: params()) :: response()
  def list_effects(operation_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: operation_id, segment: "effects")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Effect, &1}))
  end
end
