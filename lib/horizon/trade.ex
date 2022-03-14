defmodule Stellar.Horizon.Trade do
  @moduledoc """
  Represents a `Trade` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          ledger_close_time: DateTime.t(),
          trade_type: String.t(),
          base_account: String.t() | nil,
          base_offer_id: String.t() | nil,
          base_liquidity_pool_id: String.t() | nil,
          base_amount: float(),
          base_asset_type: String.t(),
          base_asset_code: String.t(),
          base_asset_issuer: String.t(),
          counter_account: String.t() | nil,
          counter_offer_id: String.t() | nil,
          counter_liquidity_pool_id: String.t() | nil,
          counter_amount: float(),
          counter_asset_type: String.t(),
          counter_asset_code: String.t(),
          counter_asset_issuer: String.t(),
          price: map(),
          base_is_seller: boolean()
        }

  defstruct [
    :id,
    :paging_token,
    :ledger_close_time,
    :trade_type,
    :base_account,
    :base_offer_id,
    :base_liquidity_pool_id,
    :base_amount,
    :base_asset_type,
    :base_asset_code,
    :base_asset_issuer,
    :counter_account,
    :counter_offer_id,
    :counter_liquidity_pool_id,
    :counter_amount,
    :counter_asset_type,
    :counter_asset_code,
    :counter_asset_issuer,
    :price,
    :base_is_seller
  ]

  @mapping [
    base_offer_id: :integer,
    ledger_close_time: :date_time,
    base_amount: :float,
    counter_amount: :float
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
