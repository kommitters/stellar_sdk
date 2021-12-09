defmodule Stellar.TxBuild.OpValidate do
  @moduledoc """
  Validates operation components.
  """
  alias Stellar.TxBuild.{Account, AccountID, Amount, Asset, OptionalAccount}

  @type account_id :: String.t()
  @type asset :: {String.t(), account_id()} | Keyword.t() | atom()
  @type value :: account_id() | asset() | number()
  @type component :: {atom(), value()}
  @type error :: Keyword.t() | atom()
  @type validation :: {:ok, any()} | {:error, Keyword.t()}

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

  @spec validate_optional_account(component :: component()) :: validation()
  def validate_optional_account({_field, nil}), do: {:ok, OptionalAccount.new()}

  def validate_optional_account({field, account_id}) do
    with {:ok, _account} <- validate_account({field, account_id}) do
      {:ok, OptionalAccount.new(account_id)}
    end
  end

  @spec validate_asset(component :: component()) :: validation()
  def validate_asset({field, asset}) do
    case Asset.new(asset) do
      %Asset{} = asset -> {:ok, asset}
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
