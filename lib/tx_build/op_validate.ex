defmodule Stellar.TxBuild.OpValidate do
  @moduledoc """
  Validates operation components.
  """
  alias Stellar.TxBuild.{Account, AccountID, Amount}

  @type account_id :: String.t()
  @type value :: account_id() | number()
  @type component :: {atom(), value()}
  @type validation :: {:ok, any()} | {:error, atom()}

  @spec validate_account_id(component :: component()) :: validation()
  def validate_account_id({field, account_id}) do
    case AccountID.new(account_id) do
      %AccountID{} = account_id -> {:ok, account_id}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end

  @spec validate_account(component :: component()) :: validation()
  def validate_account({field, account}) do
    case Account.new(account) do
      %Account{} = account -> {:ok, account}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end

  @spec validate_amount(component :: component()) :: validation()
  def validate_amount({field, amount}) do
    case Amount.new(amount) do
      %Amount{} = amount -> {:ok, amount}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end
end
