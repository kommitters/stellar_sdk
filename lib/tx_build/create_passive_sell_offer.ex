defmodule Stellar.TxBuild.CreatePassiveSellOffer do
  @moduledoc """
  Creates an offer that does not take another offer of equal price when created.
  """
  import Stellar.TxBuild.Validations,
    only: [validate_asset: 1, validate_amount: 1, validate_price: 1, validate_optional_account: 1]

  alias Stellar.TxBuild.{Amount, Asset, OptionalAccount, Price}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.CreatePassiveSellOffer}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          selling: Asset.t(),
          buying: Asset.t(),
          amount: Amount.t(),
          price: Price.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [
    :selling,
    :buying,
    :amount,
    :path,
    :price,
    :source_account
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    selling = Keyword.get(args, :selling)
    buying = Keyword.get(args, :buying)
    amount = Keyword.get(args, :amount)
    price = Keyword.get(args, :price)
    source_account = Keyword.get(args, :source_account)

    with {:ok, selling} <- validate_asset({:selling, selling}),
         {:ok, buying} <- validate_asset({:buying, buying}),
         {:ok, amount} <- validate_amount({:amount, amount}),
         {:ok, price} <- validate_price({:price, price}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        selling: selling,
        buying: buying,
        amount: amount,
        price: price,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        selling: selling,
        buying: buying,
        amount: amount,
        price: price
      }) do
    op_type = OperationType.new(:CREATE_PASSIVE_SELL_OFFER)
    selling = Asset.to_xdr(selling)
    buying = Asset.to_xdr(buying)
    amount = Amount.to_xdr(amount)
    price = Price.to_xdr(price)

    passive_sell_offer =
      CreatePassiveSellOffer.new(
        selling,
        buying,
        amount,
        price
      )

    OperationBody.new(passive_sell_offer, op_type)
  end
end
