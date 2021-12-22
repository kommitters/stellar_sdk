defmodule Stellar.TxBuild.ChangeTrust do
  @moduledoc """
  Creates, updates, or deletes a trustline.
  """
  import Stellar.TxBuild.OpValidate,
    only: [validate_asset: 1, validate_optional_account: 1, validate_optional_amount: 1]

  alias Stellar.TxBuild.{Amount, Asset, OptionalAccount}
  alias StellarBase.XDR.{ChangeTrustAsset, OperationBody, OperationType, Operations.ChangeTrust}

  @behaviour Stellar.TxBuild.XDR

  @type asset_type :: :native | :alpha_num4 | :alpha_num12
  @type component :: {atom(), any()}
  @type validation :: {:ok, any()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          asset: Asset.t(),
          amount: Amount.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:asset, :amount, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    asset = Keyword.get(args, :asset)
    amount = Keyword.get(args, :amount)
    source_account = Keyword.get(args, :source_account)

    with {:ok, asset} <- validate_asset({:asset, asset}),
         {:ok, amount} <- validate_optional_amount({:amount, amount}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        asset: asset,
        amount: amount,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{asset: asset, amount: amount}) do
    op_type = OperationType.new(:CHANGE_TRUST)
    asset_xdr = Asset.to_xdr(asset)
    amount_xdr = Amount.to_xdr(amount)

    asset_xdr.asset
    |> ChangeTrustAsset.new(asset_xdr.type)
    |> ChangeTrust.new(amount_xdr)
    |> OperationBody.new(op_type)
  end
end
