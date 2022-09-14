defmodule Stellar.Horizon.Operation.PathPaymentStrictReceive do
  @moduledoc """
  Represents a `PathPaymentStrictReceive` operation from Horizon API.
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
          source_max: String.t(),
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
    :source_max,
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
