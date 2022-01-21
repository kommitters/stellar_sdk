defmodule Stellar.Horizon.Accounts do
  @moduledoc """
  Exposes functions to interact with Accounts in Horizon.

  You can:
  - Retrieve an account.
  - Fetch next account sequence number.

  Horizon API reference: https://developers.stellar.org/api/resources/accounts/
  """

  alias Stellar.Horizon.{Account, Error}
  alias Stellar.Horizon.Client, as: Horizon

  @type account_id :: String.t()
  @type resource :: Account.t() | non_neg_integer()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "/accounts/"

  @spec retrieve(account_id :: account_id()) :: response()
  def retrieve(account_id) do
    case Horizon.request(:get, @endpoint <> account_id) do
      {:ok, account} -> {:ok, Account.new(account)}
      error -> error
    end
  end

  @spec fetch_next_sequence_number(account_id :: account_id()) :: response()
  def fetch_next_sequence_number(account_id) do
    with {:ok, %Account{sequence: sequence}} <- retrieve(account_id) do
      {:ok, sequence + 1}
    end
  end
end
