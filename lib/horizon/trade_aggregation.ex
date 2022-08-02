defmodule Stellar.Horizon.TradeAggregation do
  @moduledoc """
  Represents a `TradeAggregation` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          timestamp: non_neg_integer(),
          trade_count: non_neg_integer(),
          base_volume: float(),
          counter_volume: float(),
          avg: float(),
          high: float(),
          high_r: map(),
          low: float(),
          low_r: map(),
          open: float(),
          open_r: map(),
          close: float(),
          close_r: map()
        }

  defstruct [
    :timestamp,
    :trade_count,
    :base_volume,
    :counter_volume,
    :avg,
    :high,
    :high_r,
    :low,
    :low_r,
    :open,
    :open_r,
    :close,
    :close_r
  ]

  @rational_mapping [
    n: :integer,
    d: :integer
  ]

  @mapping [
    timestamp: :integer,
    trade_count: :integer,
    base_volume: :float,
    counter_volume: :float,
    avg: :float,
    high: :float,
    low: :float,
    open: :float,
    close: :float,
    high_r: {:map, @rational_mapping},
    low_r: {:map, @rational_mapping},
    open_r: {:map, @rational_mapping},
    close_r: {:map, @rational_mapping}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
