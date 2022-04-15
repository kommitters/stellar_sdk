defmodule Stellar.Horizon.ClaimableBalances do
  @moduledoc """
  Exposes functions to interact with ClaimableBalances in Horizon.

  You can:
  * Retrieve a claimable balance.
  * List all claimable balances.
  * List a claimable balance's transactions.
  * List a claimable balance's operations.

  Horizon API reference: https://developers.stellar.org/api/resources/claimablebalances/
  """

  alias Stellar.Horizon.{ClaimableBalance, Collection, Error, Operation, Request, Transaction}

  @type claimable_balance_id :: String.t()
  @type account_id :: String.t()
  @type asset :: String.t()
  @type options :: Keyword.t()
  @type resource :: ClaimableBalance.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "claimable_balances"

  @doc """
  Retrieves information of a specific claimable balance.

  ## Parameters:
    * `claimable_balance_id`: A unique identifier for the claimable balance.

  ## Examples

      iex> ClaimableBalances.retrieve("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695")
      {:ok, %ClaimableBalance{}}
  """
  @spec retrieve(claimable_balance_id :: claimable_balance_id()) :: response()
  def retrieve(claimable_balance_id) do
    :get
    |> Request.new(@endpoint, path: claimable_balance_id)
    |> Request.perform()
    |> Request.results(as: ClaimableBalance)
  end

  @doc """
  Lists all available claimable balances.

  ## Options

    * `sponsor`: Account ID of the sponsors.
    * `asset`: An issued asset represented as “Code:IssuerAccountID”.
    * `claimant`: Account ID of the destination address.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> ClaimableBalances.all(limit: 2, order: :asc)
      {:ok, %Collection{records: [%ClaimableBalance{}, ...]}}

      # list by sponsor
      iex> ClaimableBalances.all(sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%ClaimableBalance{}, ...]}}

      # list by claimant
      iex> ClaimableBalances.all(claimant: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", order: :desc)
      {:ok, %Collection{records: [%ClaimableBalance{}, ...]}}

      # list by canonical asset address
      iex> ClaimableBalances.all(asset: "TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD", limit: 20)
      {:ok, %Collection{records: [%ClaimableBalance{}, ...]}}
  """
  @spec all(options :: options()) :: response()
  def all(options \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(options, extra_params: [:sponsor, :asset, :claimant])
    |> Request.perform()
    |> Request.results(collection: {ClaimableBalance, &all/1})
  end

  @doc """
  Lists successful transactions referencing a given claimable balance.

  ## Parameters
    * `claimable_balance_id`: A unique identifier for the claimable balance.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.

  ## Examples

      iex> ClaimableBalances.list_transactions("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695", limit: 20)
      {:ok, %Collection{records: [%Transaction{}, ...]}}
  """
  @spec list_transactions(claimable_balance_id :: claimable_balance_id(), options :: options()) ::
          response()
  def list_transactions(claimable_balance_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: claimable_balance_id, segment: "transactions")
    |> Request.add_query(options, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(collection: {Transaction, &list_transactions(claimable_balance_id, &1)})
  end

  @doc """
  Lists successful operations referencing a given claimable balance.

  ## Parameters
    * `claimable_balance_id`: A unique identifier for the claimable balance.

  ## Options
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.
    * `include_failed`: Set to true to include failed operations in results.
    * `join`: Set to `transactions` to include the transactions which created each of the operations in the response.

  ## Examples

      iex> ClaimableBalances.list_operations("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695", limit: 20)
      {:ok, %Collection{records: [%Operation{}, ...]}}

      # join transactions
      iex> ClaimableBalances.list_operations("00000000ca6aba5fb0993844e0076f75bee53f2b8014be29cd8f2e6ae19fb0a17fc68695", join: "transactions")
      {:ok, %Collection{records: [%Operation{transaction: %Transaction{}}, ...]}}
  """
  @spec list_operations(claimable_balance_id :: claimable_balance_id(), options :: options()) ::
          response()
  def list_operations(claimable_balance_id, options \\ []) do
    :get
    |> Request.new(@endpoint, path: claimable_balance_id, segment: "operations")
    |> Request.add_query(options, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(collection: {Operation, &list_operations(claimable_balance_id, &1)})
  end

  @doc """
  Lists claimable balances matching the given sponsor.

  ## Parameters:

    * `sponsor`: Account ID of the sponsor.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> ClaimableBalances.list_by_sponsor("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%ClaimableBalance{sponsor: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}, ...]}}
  """
  @spec list_by_sponsor(sponsor :: account_id(), options :: options()) :: response()
  def list_by_sponsor(sponsor, options \\ []) do
    options
    |> Keyword.put(:sponsor, sponsor)
    |> all()
  end

  @doc """
  Lists claimable balances matching the given claimant.

  ## Parameters:

    * `claimant`: Account ID of the destination address.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> ClaimableBalances.list_by_claimant("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%ClaimableBalance{claimant: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}, ...]}}
  """
  @spec list_by_claimant(claimant :: account_id(), options :: options()) :: response()
  def list_by_claimant(claimant, options \\ []) do
    options
    |> Keyword.put(:claimant, claimant)
    |> all()
  end

  @doc """
  Lists claimable balances matching the given canonical asset.

  ## Parameters:

    * `asset`: An issued asset represented as “Code:IssuerAccountID”.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> ClaimableBalances.list_by_asset("TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%ClaimableBalance{asset: "TEST:GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}, ...]}}
  """
  @spec list_by_asset(asset :: asset(), options :: options()) :: response()
  def list_by_asset(asset, options \\ []) do
    options
    |> Keyword.put(:asset, asset)
    |> all()
  end
end
