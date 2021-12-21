defmodule Stellar.TxBuild.OpValidate do
  @moduledoc """
  Validates operation components.
  """
  alias Stellar.TxBuild.{
    Account,
    AccountID,
    Amount,
    Asset,
    AssetsPath,
    ClaimableBalanceID,
    OptionalAccount,
    OptionalAccountID,
    Price
  }

  @type account_id :: String.t()
  @type asset :: {String.t(), account_id()} | Keyword.t() | atom()
  @type value :: account_id() | asset() | number()
  @type component :: {atom(), value()}
  @type error :: Keyword.t() | atom()
  @type validation :: {:ok, any()} | {:error, error()}

  @spec validate_pos_integer(component :: component()) :: validation()
  def validate_pos_integer({_field, number}) when is_integer(number) and number >= 0,
    do: {:ok, number}

  def validate_pos_integer({field, _number}), do: {:error, [{field, :integer_expected}]}

  @spec validate_account_id(component :: component()) :: validation()
  def validate_account_id({field, account_id}) do
    case AccountID.new(account_id) do
      %AccountID{} = account_id -> {:ok, account_id}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end

  @spec validate_optional_account_id(component :: component()) :: validation()
  def validate_optional_account_id({_field, nil}), do: {:ok, OptionalAccountID.new()}

  def validate_optional_account_id({field, account_id}) do
    with {:ok, _account} <- validate_account_id({field, account_id}) do
      {:ok, OptionalAccountID.new(account_id)}
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

  @spec validate_optional_assets_path(component :: component()) :: validation()
  def validate_optional_assets_path({_field, nil}), do: {:ok, AssetsPath.new()}

  def validate_optional_assets_path({field, assets}) do
    case AssetsPath.new(assets) do
      %AssetsPath{} = assets -> {:ok, assets}
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

  @spec validate_price(component :: component()) :: validation()
  def validate_price({field, price}) do
    case Price.new(price) do
      %Price{} = price -> {:ok, price}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end

  @spec validate_claimable_balance_id(component :: component()) :: validation()
  def validate_claimable_balance_id({field, balance_id}) do
    case ClaimableBalanceID.new(balance_id) do
      %ClaimableBalanceID{} = claimable_balance_id -> {:ok, claimable_balance_id}
      {:error, reason} -> {:error, [{field, reason}]}
    end
  end
end
