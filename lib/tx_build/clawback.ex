defmodule Stellar.TxBuild.Clawback do
  @moduledoc """
  Creates a clawback operation.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{Account, Amount, Asset, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.Clawback}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          asset: Asset.t(),
          from: Account.t(),
          amount: Amount.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:asset, :from, :amount, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    from = Keyword.get(args, :from)
    asset = Keyword.get(args, :asset)
    amount = Keyword.get(args, :amount)
    source_account = Keyword.get(args, :source_account)

    with {:ok, asset} <- validate_asset({:asset, asset}),
         {:ok, from} <- validate_account({:from, from}),
         {:ok, amount} <- validate_amount({:amount, amount}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        asset: asset,
        from: from,
        amount: amount,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{asset: asset, from: from, amount: amount}) do
    op_type = OperationType.new(:CLAWBACK)
    asset = Asset.to_xdr(asset)
    from = Account.to_xdr(from)
    amount = Amount.to_xdr(amount)

    asset
    |> Clawback.new(from, amount)
    |> OperationBody.new(op_type)
  end
end
