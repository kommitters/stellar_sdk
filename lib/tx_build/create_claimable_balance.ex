defmodule Stellar.TxBuild.CreateClaimableBalance do
  @moduledoc """
  `CreateClaimableBalance` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [validate_asset: 1, validate_amount: 1, validate_optional_account: 1]

  alias Stellar.TxBuild.{Amount, Asset, Claimants, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.CreateClaimableBalance}

  @type validation :: {:ok, any()} | {:error, atom()}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          asset: Asset.t(),
          amount: Amount.t(),
          claimants: Claimants.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:asset, :amount, :claimants, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    asset = Keyword.get(args, :asset)
    amount = Keyword.get(args, :amount)
    claimants = Keyword.get(args, :claimants)
    source_account = Keyword.get(args, :source_account)

    with {:ok, asset} <- validate_asset({:asset, asset}),
         {:ok, amount} <- validate_amount({:amount, amount}),
         {:ok, claimants} <- validate_claimants(claimants),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        asset: asset,
        amount: amount,
        claimants: claimants,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        asset: asset,
        amount: amount,
        claimants: claimants
      }) do
    op_type = OperationType.new(:CREATE_CLAIMABLE_BALANCE)
    asset = Asset.to_xdr(asset)
    amount = Amount.to_xdr(amount)
    claimants = Claimants.to_xdr(claimants)

    claimable_balance =
      CreateClaimableBalance.new(
        asset,
        amount,
        claimants
      )

    OperationBody.new(claimable_balance, op_type)
  end

  @spec validate_claimants(claimants :: Claimants.t()) :: validation()
  defp validate_claimants(claimants) do
    case claimants do
      %Claimants{} = claimants -> {:ok, claimants}
      _error -> {:error, :invalid_claimant_list}
    end
  end
end
