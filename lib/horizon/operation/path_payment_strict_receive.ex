defmodule Stellar.Horizon.Operation.PathPaymentStrictReceive do
  @moduledoc """
  Represents a `PathPaymentStrictReceive` operation from Horizon API.
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

  @mapping [amount: :float, source_amount: :float, source_max: :float]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
