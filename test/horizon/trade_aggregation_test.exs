defmodule Stellar.Horizon.TradeAggregationTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.TradeAggregation

  setup do
    json_body = Horizon.fixture("trade_aggregation")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %TradeAggregation{
      avg: 25.4268566,
      base_volume: 3487.4699458,
      close: 25.7090558,
      close_r: %{d: 48_621, n: 1_250_000},
      counter_volume: 88_675.3982178,
      high: 25.7603393,
      high_r: %{d: 10_000_000, n: 257_603_393},
      low: 25.380453,
      low_r: %{d: 1_000_000, n: 25_380_453},
      open: 25.3990186,
      open_r: %{d: 98_429, n: 2_500_000},
      timestamp: 1_582_156_800_000,
      trade_count: 9
    } = TradeAggregation.new(attrs)
  end

  test "new/2 empty_attrs" do
    %TradeAggregation{
      avg: nil,
      base_volume: nil,
      close: nil,
      close_r: nil,
      counter_volume: nil,
      high: nil,
      high_r: nil,
      low: nil,
      low_r: nil,
      open: nil,
      open_r: nil,
      timestamp: nil,
      trade_count: nil
    } = TradeAggregation.new(%{})
  end
end
