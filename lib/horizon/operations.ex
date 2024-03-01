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

  alias Stellar.Horizon.{Collection, Effect, Error, Operation, Request, Server}

  @type operation_id :: String.t()
  @type options :: Keyword.t()
  @type resource :: Operation.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}
  @type server :: Server.t()

  @endpoint "operations"
  @payments_endpoint "payments"

  @doc """
  Retrieves information of a specific operation.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `operation_id`: The ID number for the operation.

  ## Examples

      iex> Operations.retrieve(Stellar.Horizon.Server.testnet(), 121693057904021505)
      {:ok, %Operation{}}
  """
  @spec retrieve(server :: server(), operation_id :: operation_id(), options :: options()) ::
          response()
  def retrieve(server, operation_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: operation_id)
    |> Request.add_query(options, extra_params: [:join])
    |> Request.perform()
    |> Request.results(as: Operation)
  end

  @doc """
  Lists all successful operations.

  ## Parameters:
    * `server`: The Horizon server to query.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Operations.all(Stellar.Horizon.Server.testnet(), limit: 10, order: :asc)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # include failed
      iex> Operations.all(Stellar.Horizon.Server.testnet(), limit: 10, include_failed: true)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # join transactions
      iex> Operations.all(Stellar.Horizon.Server.testnet(), limit: 10, join: "transactions")
      {:ok, %Collection{records: [%Operation{transaction: %Transaction{}}, ...]}}
  """
  @spec all(server :: server(), options :: options()) :: response()
  def all(server, options \\ []) do
    server
    |> Request.new(:get, @endpoint)
    |> Request.add_query(options, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &all(server, &1)})
  end

  @doc """
  Lists successful payment-related operations.

  ## Parameters
    * `server`: The Horizon server to query.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Operations.list_payments(Stellar.Horizon.Server.testnet(), limit: 20)
      {:ok, %Collection{records: [%Operation{body: %Payment{}}, ...]}}
  """
  @spec list_payments(server :: server(), options :: options()) :: response()
  def list_payments(server, options \\ []) do
    server
    |> Request.new(:get, @payments_endpoint)
    |> Request.add_query(options, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_payments(server, &1)})
  end

  @doc """
  Lists the effects of a specific operation.

  ## Parameters
    * `server`: The Horizon server to query.
    * `operation_id`: The ID number for the operation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Operations.list_effects(Stellar.Horizon.Server.testnet(), 121693057904021505, limit: 20)
      {:ok, %Collection{records: [%Effect{}, ...]}}
  """
  @spec list_effects(server :: server(), operation_id :: operation_id(), options :: options()) ::
          response()
  def list_effects(server, operation_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: operation_id, segment: "effects")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Effect, &list_effects(server, operation_id, &1)})
  end
end
