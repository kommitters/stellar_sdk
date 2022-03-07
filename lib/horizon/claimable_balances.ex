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
  @type params :: Keyword.t()
  @type resource :: ClaimableBalance.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "claimable_balances"

  @spec retrieve(claimable_balance_id :: claimable_balance_id()) :: response()
  def retrieve(claimable_balance_id) do
    :get
    |> Request.new(@endpoint, path: claimable_balance_id)
    |> Request.perform()
    |> Request.results(&ClaimableBalance.new(&1))
  end

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: [:sponsor, :asset, :claimant])
    |> Request.perform()
    |> Request.results(&Collection.new({ClaimableBalance, &1}))
  end

  @spec list_transactions(claimable_balance_id :: claimable_balance_id(), params :: params()) ::
          response()
  def list_transactions(claimable_balance_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: claimable_balance_id, segment: "transactions")
    |> Request.add_query(params, extra_params: [:include_failed])
    |> Request.perform()
    |> Request.results(&Collection.new({Transaction, &1}))
  end

  @spec list_operations(claimable_balance_id :: claimable_balance_id(), params :: params()) ::
          response()
  def list_operations(claimable_balance_id, params \\ []) do
    :get
    |> Request.new(@endpoint, path: claimable_balance_id, segment: "operations")
    |> Request.add_query(params, extra_params: [:include_failed, :join])
    |> Request.perform()
    |> Request.results(&Collection.new({Operation, &1}))
  end

  @spec list_by_sponsor(sponsor :: account_id(), params :: params()) :: response()
  def list_by_sponsor(sponsor, params \\ []) do
    params
    |> Keyword.put(:sponsor, sponsor)
    |> all()
  end

  @spec list_by_claimant(claimant :: account_id(), params :: params()) :: response()
  def list_by_claimant(claimant, params \\ []) do
    params
    |> Keyword.put(:claimant, claimant)
    |> all()
  end

  @spec list_by_asset(asset :: asset(), params :: params()) :: response()
  def list_by_asset(asset, params \\ []) do
    params
    |> Keyword.put(:asset, asset)
    |> all()
  end
end
