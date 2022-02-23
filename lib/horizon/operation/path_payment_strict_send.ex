defmodule Stellar.Horizon.Operation.PathPaymentStrictSend do
  @moduledoc """
  Represents a `PathPaymentStrictSend` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset_type: float(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          from: String.t(),
          to: String.t(),
          amount: float(),
          path: list(),
          source_amount: String.t(),
          destination_min: String.t(),
          source_asset_type: String.t(),
          source_asset_code: String.t(),
          source_asset_issuer: String.t()
        }

  defstruct [
    :asset_type,
    :asset_code,
    :asset_issuer,
    :from,
    :to,
    :amount,
    :path,
    :source_amount,
    :destination_min,
    :source_asset_type,
    :source_asset_code,
    :source_asset_issuer
  ]

  @mapping [amount: :float, source_amount: :float, destination_min: :float]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
