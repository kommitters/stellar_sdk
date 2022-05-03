defmodule Stellar.TxBuild.Ledger.Trustline do
  @moduledoc """
  Ledger `Trustline` struct definition.
  """
  alias StellarBase.XDR.TrustLine
  alias Stellar.TxBuild.{AccountID, TrustlineAsset}

  @behaviour Stellar.TxBuild.XDR

  @type account_id :: String.t()
  @type asset :: atom() | Keyword.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{account: AccountID.t(), asset: TrustlineAsset.t()}

  defstruct [:account, :asset]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) do
    account = Keyword.get(args, :account)
    asset = Keyword.get(args, :asset)

    with {:ok, account} <- validate_account(account),
         {:ok, asset} <- validate_trustline_asset(asset) do
      %__MODULE__{account: account, asset: asset}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{account: account, asset: asset}) do
    trustline = TrustlineAsset.to_xdr(asset)

    account
    |> AccountID.to_xdr()
    |> TrustLine.new(trustline)
  end

  @spec validate_account(account_id :: account_id()) :: validation()
  defp validate_account(account_id) do
    case AccountID.new(account_id) do
      %AccountID{} = account -> {:ok, account}
      _error -> {:error, :invalid_account}
    end
  end

  @spec validate_trustline_asset(asset :: asset()) :: validation()
  defp validate_trustline_asset(asset) do
    case TrustlineAsset.new(asset) do
      %TrustlineAsset{} = trustline_asset -> {:ok, trustline_asset}
      _error -> {:error, :invalid_asset}
    end
  end
end
