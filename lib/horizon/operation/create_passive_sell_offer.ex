defmodule Stellar.Horizon.Operation.CreatePassiveSellOffer do
  @moduledoc """
  Represents a `CreatePassiveSellOffer` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          amount: String.t(),
          price: String.t(),
          price_r: map(),
          buying_asset_type: String.t(),
          buying_asset_issuer: String.t(),
          buying_asset_code: String.t(),
          selling_asset_type: String.t(),
          selling_asset_issuer: String.t(),
          selling_asset_code: String.t(),
          offer_id: String.t()
        }

  defstruct [
    :amount,
    :price,
    :price_r,
    :buying_asset_type,
    :buying_asset_issuer,
    :buying_asset_code,
    :selling_asset_type,
    :selling_asset_issuer,
    :selling_asset_code,
    :offer_id
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
