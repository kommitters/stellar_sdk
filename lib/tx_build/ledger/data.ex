defmodule Stellar.TxBuild.Ledger.Data do
  @moduledoc """
  Ledger `Data` struct definition.
  """
  alias StellarBase.XDR.{Data, String64}
  alias Stellar.TxBuild.AccountID

  @behaviour Stellar.TxBuild.XDR

  @type account_id :: String.t()
  @type data_name :: String.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{account: AccountID.t(), data_name: data_name()}

  defstruct [:account, :data_name]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) do
    account_id = Keyword.get(args, :account)
    data_name = Keyword.get(args, :data_name)

    with {:ok, account} <- validate_account(account_id),
         {:ok, data_name} <- validate_data_name(data_name) do
      %__MODULE__{account: account, data_name: data_name}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{account: account, data_name: data_name}) do
    data_name = String64.new(data_name)

    account
    |> AccountID.to_xdr()
    |> Data.new(data_name)
  end

  @spec validate_account(account_id :: account_id()) :: validation()
  defp validate_account(account_id) do
    case AccountID.new(account_id) do
      %AccountID{} = account -> {:ok, account}
      _error -> {:error, :invalid_account}
    end
  end

  @spec validate_data_name(data_name :: data_name()) :: validation()
  defp validate_data_name(data_name) when byte_size(data_name) <= 64, do: {:ok, data_name}
  defp validate_data_name(_data_name), do: {:error, :invalid_data_name}
end
