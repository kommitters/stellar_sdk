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
    Transaction,
    Server
  }

  @type sequence :: non_neg_integer()
  @type params :: Keyword.t()
  @type resource :: Ledger.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}
  @type server :: Server.t()

  @endpoint "ledgers"

  @doc """
  Retrieves information of a specific ledger.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `sequence`: The sequence number of a specific ledger.

  ## Examples

      iex> Ledgers.retrieve(Stellar.Horizon.Server.testnet(), 27147222)
      {:ok, %Ledger{}}
  """
  @spec retrieve(server :: server(), sequence :: sequence()) :: response()
  def retrieve(server, sequence) do
    server
    |> Request.new(:get, @endpoint, path: sequence)
    |> Request.perform()
    |> Request.results(as: Ledger)
  end

  @doc """
  Lists all ledgers.

  ## Parameters:
    * `server`: The Horizon server to query.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Ledgers.all(Stellar.Horizon.Server.testnet(), limit: 10, order: :asc)
      {:ok, %Collection{records: [%Ledger{}, ...]}}
  """
  @spec all(server :: server(), params :: params()) :: response()
  def all(server, params \\ []) do
    server
    |> Request.new(:get, @endpoint)
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(collection: {Ledger, &all(server, &1)})
  end

  @doc """
  Lists successful transactions in a specific ledger.

  ## Parameters
    * `server`: The Horizon server to query.
    * `sequence`: The sequence number of a specific ledger.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.

  ## Examples

      iex> Ledgers.list_transactions(Stellar.Horizon.Server.testnet(), 27147222, limit: 20)
      {:ok, %Collection{records: [%Transaction{}, ...]}}
  """
  @spec list_transactions(server :: server(), sequence :: sequence(), params :: params()) ::
          response()
  def list_transactions(server, sequence, params \\ []) do
    server
    |> Request.new(:get, @endpoint, path: sequence, segment: "transactions")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(collection: {Transaction, &list_transactions(server, sequence, &1)})
  end

  @doc """
  Lists successful operations in a specific ledger.

  ## Parameters
    * `server`: The Horizon server to query.
    * `sequence`: The sequence number of a specific ledger.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Ledgers.list_operations(Stellar.Horizon.Server.testnet(), 27147222, limit: 20)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # join transactions
      iex> Ledgers.list_operations(Stellar.Horizon.Server.testnet(), 27147222, join: "transactions")
      {:ok, %Collection{records: [%Operation{transaction: %Transaction{}}, ...]}}
  """
  @spec list_operations(server :: server(), sequence :: sequence(), params :: params()) ::
          response()
  def list_operations(server, sequence, params \\ []) do
    server
    |> Request.new(:get, @endpoint, path: sequence, segment: "operations")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_operations(server, sequence, &1)})
  end

  @doc """
  Lists successful payments in a specific ledger.

  ## Parameters
    * `server`: The Horizon server to query.
    * `sequence`: The sequence number of a specific ledger.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Ledgers.list_payments(Stellar.Horizon.Server.testnet(), 27147222, limit: 20)
      {:ok, %Collection{records: [%Operation{body: %Payment{}}, ...]}}

      # include failed
      iex> Ledgers.list_payments(Stellar.Horizon.Server.testnet(), 27147222, include_failed: true)
      {:ok, %Collection{records: [%Operation{body: %Payment{}}, ...]}}
  """
  @spec list_payments(server :: server(), sequence :: sequence(), params :: params()) ::
          response()
  def list_payments(server, sequence, params \\ []) do
    server
    |> Request.new(:get, @endpoint, path: sequence, segment: "payments")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_payments(server, sequence, &1)})
  end

  @doc """
  Lists the effects of a specific ledger.

  ## Parameters
    * `server`: The Horizon server to query.
    * `sequence`: The sequence number of a specific ledger.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Ledgers.list_effects(Stellar.Horizon.Server.testnet(), 27147222, limit: 20)
      {:ok, %Collection{records: [%Effect{}, ...]}}
  """
  @spec list_effects(server :: server(), sequence :: sequence(), params :: params()) :: response()
  def list_effects(server, sequence, params \\ []) do
    server
    |> Request.new(:get, @endpoint, path: sequence, segment: "effects")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(collection: {Effect, &list_effects(server, sequence, &1)})
  end
end
