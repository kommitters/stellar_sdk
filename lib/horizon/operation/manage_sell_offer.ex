defmodule Stellar.Horizon.Operation.ManageSellOffer do
  @moduledoc """
  Represents a `ManageSellOffer` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          amount: float(),
          price: float(),
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

  @mapping [amount: :float, price: :float]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
