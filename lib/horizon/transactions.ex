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

  alias Stellar.Horizon.{Collection, Effect, Error, Operation, Transaction, Request, Server}

  @type server :: Server.t()
  @type hash :: String.t()
  @type options :: Keyword.t()
  @type resource :: Transaction.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "transactions"
  @endpoint_async "transactions_async"

  @doc """
  Creates a transaction to the Stellar network.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `tx`: The base64-encoded XDR of the transaction.

  ## Examples

      iex> Transactions.create(Stellar.Horizon.Server.testnet(), "AAAAAgAAAACQcEK2yfQA9CHrX+2UMkRIb/1wzltKqHpbdIcJbp+b/QAAAGQAAiEYAAAAAQAAAAEAAAAAAAAAAAAAAABgXP3QAAAAAQAAABBUZXN0IFRyYW5zYWN0aW9uAAAAAQAAAAAAAAABAAAAAJBwQrbJ9AD0Ietf7ZQyREhv/XDOW0qoelt0hwlun5v9AAAAAAAAAAAF9eEAAAAAAAAAAAFun5v9AAAAQKdJnG8QRiv9xGp1Oq7ACv/xR2BnNqjfUHrGNua7m4tWbrun3+GmAj6ca3xz+4ZppWRTbvTUcCxvpbHERZ85QgY=")
      {:ok, %Transaction{}}
  """
  @spec create(server :: server(), base64_envelope :: String.t()) :: response()
  def create(server, base64_envelope) do
    server
    |> Request.new(:post, @endpoint)
    |> Request.add_headers([{"Content-Type", "application/x-www-form-urlencoded"}])
    |> Request.add_body(tx: base64_envelope)
    |> Request.perform()
    |> Request.results(as: Transaction)
  end

  @doc """
  Retrieves information of a specific transaction.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `hash`: A hex-encoded SHA-256 hash of this transaction’s XDR-encoded form.

  ## Examples

      iex> Transactions.retrieve(Stellar.Horizon.Server.testnet(), "5ebd5c0af4385500b53dd63b0ef5f6e8feef1a7e1c86989be3cdcce825f3c0cc")
      {:ok, %Transaction{}}
  """
  @spec retrieve(server :: server(), hash :: hash()) :: response()
  def retrieve(server, hash) do
    server
    |> Request.new(:get, @endpoint, path: hash)
    |> Request.perform()
    |> Request.results(as: Transaction)
  end

  @doc """
  Lists all successful transactions.

  ## Parameters:
    * `server`: The Horizon server to query.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.

  ## Examples

      iex> Transactions.all(Stellar.Horizon.Server.testnet(), limit: 10, order: :asc)
      {:ok, %Collection{records: [%Transaction{}, ...]}}

      # include failed
      iex> Transactions.all(Stellar.Horizon.Server.testnet(), limit: 10, include_failed: true)
      {:ok, %Collection{records: [%Transaction{}, ...]}}
  """
  @spec all(server :: server(), options :: options()) :: response()
  def all(server, options \\ []) do
    server
    |> Request.new(:get, @endpoint)
    |> Request.add_query(options, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(collection: {Transaction, &all(server, &1)})
  end

  @doc """
  Lists the effects of a specific transaction.

  ## Parameters
    * `server`: The Horizon server to query.
    * `hash`: A hex-encoded SHA-256 hash of this transaction’s XDR-encoded form.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Transactions.list_effects(Stellar.Horizon.Server.testnet(), "6b983a4e0dc3c04f4bd6b9037c55f70a09c434dfd01492be1077cf7ea68c2e4a", limit: 20)
      {:ok, %Collection{records: [%Effect{}, ...]}}
  """
  @spec list_effects(server :: server(), hash :: hash(), options :: options()) :: response()
  def list_effects(server, hash, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: hash, segment: "effects")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Effect, &list_effects(server, hash, &1)})
  end

  @doc """
  Lists successful operations for a specific transaction.

  ## Parameters
    * `server`: The Horizon server to query.
    * `hash`: A hex-encoded SHA-256 hash of this transaction’s XDR-encoded form.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Transactions.list_operations(Stellar.Horizon.Server.testnet(), "6b983a4e0dc3c04f4bd6b9037c55f70a09c434dfd01492be1077cf7ea68c2e4a", limit: 20)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # join transactions
      iex> Transactions.list_operations(Stellar.Horizon.Server.testnet(), "6b983a4e0dc3c04f4bd6b9037c55f70a09c434dfd01492be1077cf7ea68c2e4a", join: "transactions")
      {:ok, %Collection{records: [%Operation{transaction: %Transaction{}}, ...]}}
  """
  @spec list_operations(server :: server(), hash :: hash(), options :: options()) :: response()
  def list_operations(server, hash, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: hash, segment: "operations")
    |> Request.add_query(options, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_operations(server, hash, &1)})
  end

  @doc """
    Creates a transaction to the Stellar network asynchronously.

    ## Parameters:
      * `server`: The Horizon server to query.
      * `tx`: The base64-encoded XDR of the transaction.

    ## Examples

        iex> Transactions.create_async(Stellar.Horizon.Server.testnet(), "AAAAAgAAAACQcEK2yfQA9CHrX+2UMkRIb/1wzltKqHpbdIcJbp+b/QAAAGQAAiEYAAAAAQAAAAEAAAAAAAAAAAAAAABgXP3QAAAAAQAAABBUZXN0IFRyYW5zYWN0aW9uAAAAAQAAAAAAAAABAAAAAJBwQrbJ9AD0Ietf7ZQyREhv/XDOW0qoelt0hwlun5v9AAAAAAAAAAAF9eEAAAAAAAAAAAFun5v9AAAAQKdJnG8QRiv9xGp1Oq7ACv/xR2BnNqjfUHrGNua7m4tWbrun3+GmAj6ca3xz+4ZppWRTbvTUcCxvpbHERZ85QgY=")
        {:ok, %Transaction{}}
  """
  @spec create_async(server :: server(), base64_envelope :: String.t()) :: response()
  def create_async(server, base64_envelope) do
    server
    |> Request.new(:post, @endpoint_async)
    |> Request.add_headers([{"Content-Type", "application/x-www-form-urlencoded"}])
    |> Request.add_body(tx: base64_envelope)
    |> Request.perform()
    |> Request.results(as: Transaction)
  end
end
