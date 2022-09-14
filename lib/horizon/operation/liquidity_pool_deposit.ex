defmodule Stellar.Horizon.Operation.LiquidityPoolDeposit do
  @moduledoc """
  Represents a `LiquidityPoolDeposit` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          liquidity_pool_id: String.t(),
          reserves_max: list(map()),
          min_price: String.t(),
          min_price_r: map(),
          max_price: String.t(),
          max_price_r: map(),
          reserves_deposited: list(map()),
          shares_received: integer()
        }

  defstruct [
    :liquidity_pool_id,
    :reserves_max,
    :min_price,
    :min_price_r,
    :max_price,
    :max_price_r,
    :reserves_deposited,
    :shares_received
  ]

  @mapping [shares_received: :integer]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
