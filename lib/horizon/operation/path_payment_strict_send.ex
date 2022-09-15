defmodule Stellar.Horizon.Operation.PathPaymentStrictSend do
  @moduledoc """
  Represents a `PathPaymentStrictSend` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset_type: String.t(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          from: String.t(),
          to: String.t(),
          amount: String.t(),
          path: list(map()),
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

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
