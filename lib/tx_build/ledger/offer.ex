defmodule Stellar.TxBuild.Ledger.Offer do
  @moduledoc """
  Ledger `Offer` struct definition.
  """
  alias StellarBase.XDR.{Int64, Offer}
  alias Stellar.TxBuild.AccountID

  @behaviour Stellar.TxBuild.XDR

  @type seller_id :: String.t()
  @type offer_id :: non_neg_integer()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{seller_id: AccountID.t(), offer_id: offer_id()}

  defstruct [:seller_id, :offer_id]

  @max_offer_id 9_223_372_036_854_775_807

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) do
    seller_id = Keyword.get(args, :seller_id)
    offer_id = Keyword.get(args, :offer_id)

    with {:ok, seller_id} <- validate_seller(seller_id),
         {:ok, offer_id} <- validate_offer_id(offer_id) do
      %__MODULE__{seller_id: seller_id, offer_id: offer_id}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{seller_id: seller_id, offer_id: offer_id}) do
    offer = Int64.new(offer_id)

    seller_id
    |> AccountID.to_xdr()
    |> Offer.new(offer)
  end

  @spec validate_seller(seller_id :: seller_id()) :: validation()
  defp validate_seller(seller_id) do
    case AccountID.new(seller_id) do
      %AccountID{} = seller_id -> {:ok, seller_id}
      _error -> {:error, :invalid_seller}
    end
  end

  @spec validate_offer_id(offer_id :: offer_id()) :: validation()
  defp validate_offer_id(offer_id) when is_integer(offer_id) and offer_id <= @max_offer_id,
    do: {:ok, offer_id}

  defp validate_offer_id(_offer_id), do: {:error, :invalid_offer_id}
end
