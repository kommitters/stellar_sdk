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
    Transaction
  }

  @type account_id :: String.t()
  @type params :: Keyword.t()
  @type resource :: Account.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "accounts"

  @spec retrieve(account_id :: account_id()) :: response()
  def retrieve(account_id) do
    :get
    |> Request.new(@endpoint, path: account_id)
    |> Request.perform()
    |> Request.results(&Account.new(&1))
  end

  @spec fetch_next_sequence_number(account_id :: account_id()) :: response()
  def fetch_next_sequence_number(account_id) do
    case retrieve(account_id) do
      {:ok, %Account{sequence: sequence}} -> {:ok, sequence + 1}
      error -> error
    end
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: [:sponsor, :asset, :signer, :liquidity_pool])
    |> Request.perform()
    |> Request.results(&Collection.new({Account, &1}))
  end

  @spec list_transactions(account_id :: account_id(), params :: params()) :: response()
  def list_transactions(account_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "transactions")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Transaction, &1}))
  end

  @spec list_operations(account_id :: account_id(), params :: params()) :: response()
  def list_operations(account_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "operations")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec list_payments(account_id :: account_id(), params :: params()) :: response()
  def list_payments(account_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "payments")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec list_effects(account_id :: account_id(), params :: params()) :: response()
  def list_effects(account_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "effects")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Effect, &1}))
  end

  @spec list_offers(account_id :: account_id(), params :: params()) :: response()
  def list_offers(account_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "offers")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Offer, &1}))
  end

  @spec list_trades(account_id :: account_id(), params :: params()) :: response()
  def list_trades(account_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "trades")
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Trade, &1}))
  end

  @spec data(account_id :: account_id(), key :: String.t()) :: response()
  def data(account_id, key) do
    :get
    |> Request.new(@endpoint, path: account_id, segment: "data", segment_path: key)
    |> Request.perform()
    |> Request.results(&Data.new(&1))
  end
end
