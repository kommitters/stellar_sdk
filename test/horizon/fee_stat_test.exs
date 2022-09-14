defmodule Stellar.Horizon.FeeStatTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.FeeStat

  setup do
    json_body = Horizon.fixture("fee_stats")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %FeeStat{
      fee_charged: %{
        max: "100",
        min: "100",
        mode: "100",
        p10: "100",
        p20: "100",
        p30: "100",
        p40: "100",
        p50: "100",
        p60: "100",
        p70: "100",
        p80: "100",
        p90: "100",
        p95: "100",
        p99: "100"
      },
      last_ledger: 155_545,
      last_ledger_base_fee: 100,
      ledger_capacity_usage: "0.01",
      max_fee: %{
        max: "100",
        min: "100",
        mode: "100",
        p10: "100",
        p20: "100",
        p30: "100",
        p40: "100",
        p50: "100",
        p60: "100",
        p70: "100",
        p80: "100",
        p90: "100",
        p95: "100",
        p99: "100"
      }
    } = FeeStat.new(attrs)
  end

  test "new/2 empty_attrs" do
    %FeeStat{
      fee_charged: nil,
      last_ledger: nil,
      last_ledger_base_fee: nil,
      ledger_capacity_usage: nil,
      max_fee: nil
    } = FeeStat.new(%{})
  end
end
