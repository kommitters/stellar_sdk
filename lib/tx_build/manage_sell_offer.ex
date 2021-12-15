defmodule Stellar.TxBuild.ManageSellOffer do
  @moduledoc """
  Creates, updates, or deletes an offer.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{Amount, Asset, OptionalAccount, Price}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.ManageSellOffer, Int64}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          selling: Asset.t(),
          buying: Asset.t(),
          amount: Amount.t(),
          price: Price.t(),
          offer_id: integer(),
          source_account: OptionalAccount.t()
        }

  defstruct [
    :selling,
    :buying,
    :amount,
    :path,
    :price,
    :offer_id,
    :source_account
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    selling = Keyword.get(args, :selling)
    buying = Keyword.get(args, :buying)
    amount = Keyword.get(args, :amount)
    price = Keyword.get(args, :price)
    offer_id = Keyword.get(args, :offer_id)
    source_account = Keyword.get(args, :source_account)

    with {:ok, selling} <- validate_asset({:selling, selling}),
         {:ok, buying} <- validate_asset({:buying, buying}),
         {:ok, amount} <- validate_amount({:amount, amount}),
         {:ok, price} <- validate_price({:price, price}),
         {:ok, offer_id} <- validate_pos_integer({:offer_id, offer_id}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        selling: selling,
        buying: buying,
        amount: amount,
        price: price,
        offer_id: offer_id,
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
        price: price,
        offer_id: offer_id
      }) do
    op_type = OperationType.new(:MANAGE_SELL_OFFER)
    selling = Asset.to_xdr(selling)
    buying = Asset.to_xdr(buying)
    amount = Amount.to_xdr(amount)
    price = Price.to_xdr(price)
    offer_id = Int64.new(offer_id)

    manage_sell_offer =
      ManageSellOffer.new(
        selling,
        buying,
        amount,
        price,
        offer_id
      )

    OperationBody.new(manage_sell_offer, op_type)
  end
end
