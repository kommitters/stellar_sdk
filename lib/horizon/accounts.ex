defmodule Stellar.Horizon.Accounts do
  @moduledoc """
  Exposes functions to interact with Accounts in Horizon.

  You can:
  * Retrieve an account.
  * Fetch an account next sequence number.
  * List all accounts.
  * List an account's effects.
  * List an account's offers.
  * List an account's trades.
  * List an account's transactions.
  * List an account's operations.
  * List an account's payments.
  * List an account's data.

  Horizon API reference: https://developers.stellar.org/api/resources/accounts/
  """

  alias Stellar.Horizon.{
    Account,
    Account.Data,
    Collection,
    Effect,
    Error,
    Offer,
    Operation,
    Request,
    Trade,
    Transaction,
    Server
  }

  @type server :: Server.t()
  @type account_id :: String.t()
  @type options :: Keyword.t()
  @type resource :: Account.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "accounts"

  @doc """
  Retrieves information of a specific account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Examples

      iex> Accounts.retrieve(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Account{}}
  """
  @spec retrieve(server :: server(), account_id :: account_id()) :: response()
  def retrieve(server, account_id) do
    server
    |> Request.new(:get, @endpoint, path: account_id)
    |> Request.perform()
    |> Request.results(as: Account)
  end

  @doc """
  Fetches the ledger's sequence number for the given account.

  ## Parameters:

    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Examples

      iex> Accounts.fetch_next_sequence_number(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, 17218523889687}
  """
  @spec fetch_next_sequence_number(server :: server(), account_id :: account_id()) :: response()
  def fetch_next_sequence_number(server, account_id) do
    case retrieve(server, account_id) do
      {:ok, %Account{sequence: sequence}} -> {:ok, sequence + 1}
      error -> error
    end
  end

  @doc """
  Lists all accounts or by one of these three filters: `signer`, `asset`, or `sponsor`.

  ## Parameters:
    * `server`: The Horizon server to query.

  ## Options

    * `signer`: Account ID of the signer.
    * `asset`: An issued asset represented as “Code:IssuerAccountID”.
    * `sponsor`: Account ID of the sponsor.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Accounts.all(Stellar.Horizon.Server.testnet(), limit: 2, order: :asc)
      {:ok, %Collection{records: [%Account{}, ...]}}

      # list by sponsor
      iex> Accounts.all(Stellar.Horizon.Server.testnet(), sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%Account{}, ...]}}

      # list by signer
      iex> Accounts.all(Stellar.Horizon.Server.testnet(), signer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)
      {:ok, %Collection{records: [%Account{}, ...]}}

      # list by canonical asset address
      iex> Accounts.all(Stellar.Horizon.Server.testnet(), asset: "TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Account{}, ...]}}
  """
  @spec all(server :: server(), options :: options()) :: response()
  def all(server, options \\ []) do
    server
    |> Request.new(:get, @endpoint)
    |> Request.add_query(options, extra_params: [:sponsor, :asset, :signer, :liquidity_pool])
    |> Request.perform()
    |> Request.results(collection: {Account, &all(server, &1)})
  end

  @doc """
  Lists successful transactions for a given account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.

  ## Examples

      iex> Accounts.list_transactions(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Transaction{}, ...]}}
  """
  @spec list_transactions(server :: server(), account_id :: account_id(), options :: options()) ::
          response()
  def list_transactions(server, account_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "transactions")
    |> Request.add_query(options, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(collection: {Transaction, &list_transactions(server, account_id, &1)})
  end

  @doc """
  Lists successful operations for a given account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Accounts.list_transactions(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # join transactions
      iex> Accounts.list_transactions(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", join: "transactions")
      {:ok, %Collection{records: [%Operation{transaction: %Transaction{}}, ...]}}
  """
  @spec list_operations(server :: server(), account_id :: account_id(), options :: options()) ::
          response()
  def list_operations(server, account_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "operations")
    |> Request.add_query(options, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_operations(server, account_id, &1)})
  end

  @doc """
  Lists successful payments for a given account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> Accounts.list_payments(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Operation{body: %Payment{}}, ...]}}

      # include failed
      iex> Accounts.list_payments(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", include_failed: true)
      {:ok, %Collection{records: [%Operation{body: %Payment{}}, ...]}}
  """
  @spec list_payments(server :: server(), account_id :: account_id(), options :: options()) ::
          response()
  def list_payments(server, account_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "payments")
    |> Request.add_query(options, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_payments(server, account_id, &1)})
  end

  @doc """
  Lists the effects of a specific account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Accounts.list_effects(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Effect{}, ...]}}
  """
  @spec list_effects(server :: server(), account_id :: account_id(), options :: options()) ::
          response()
  def list_effects(server, account_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "effects")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Effect, &list_effects(server, account_id, &1)})
  end

  @doc """
  Lists all offers a given account has currently open.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Accounts.list_offers(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Offer{}, ...]}}
  """
  @spec list_offers(server :: server(), account_id :: account_id(), options :: options()) ::
          response()
  def list_offers(server, account_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "offers")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Offer, &list_offers(server, account_id, &1)})
  end

  @doc """
  Lists all trades for a given account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Accounts.list_trades(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%Trade{}, ...]}}
  """
  @spec list_trades(server :: server(), account_id :: account_id(), options :: options()) ::
          response()
  def list_trades(server, account_id, options \\ []) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "trades")
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Trade, &list_trades(server, account_id, &1)})
  end

  @doc """
  Retrieves a single data for a given account.

  ## Parameters:
    * `server`: The Horizon server to query.
    * `account_id`: The account’s public key encoded in a base32 string representation.
    * `key`: The key name for this data.

  ## Examples

      iex> Accounts.data(Stellar.Horizon.Server.testnet(), "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", "config.memo_required")
      {:ok, %Account.Data{}}
  """
  @spec data(server :: server(), account_id :: account_id(), key :: String.t()) :: response()
  def data(server, account_id, key) do
    server
    |> Request.new(:get, @endpoint, path: account_id, segment: "data", segment_path: key)
    |> Request.perform()
    |> Request.results(as: Data)
  end
end
