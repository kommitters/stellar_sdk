defmodule Stellar.Horizon.Operation.LiquidityPoolDeposit do
  @moduledoc """
  Represents a `LiquidityPoolDeposit` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          liquidity_pool_id: String.t(),
          reserves_max: list(map()),
          min_price: float(),
          min_price_r: map(),
          max_price: float(),
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

  @mapping [
    min_price: :float,
    max_price: :float,
    shares_received: :integer,
    reserves_max: {:list, :map, [amount: :float]},
    reserves_deposited: {:list, :map, [amount: :float]}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
