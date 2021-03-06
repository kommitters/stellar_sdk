defmodule Stellar.TxBuild.TimeBoundsTest do
  use ExUnit.Case

  alias StellarBase.XDR.{TimePoint, OptionalTimeBounds}
  alias StellarBase.XDR.TimeBounds, as: TimeBoundsXDR
  alias Stellar.TxBuild.TimeBounds

  test "new/2" do
    %TimeBounds{min_time: 0, max_time: 0} = TimeBounds.new()
  end

  test "new/2 with_integer_values" do
    %TimeBounds{min_time: 0, max_time: 123} = TimeBounds.new(min_time: 0, max_time: 123)
  end

  test "new/2 with_date_time_values" do
    max_time = ~U[2022-02-03 22:24:59.385352Z]

    %TimeBounds{min_time: 0, max_time: 1_643_927_099} =
      TimeBounds.new(min_time: 0, max_time: max_time)
  end

  test "new/2 with_invalid_values" do
    {:error, :invalid_time_bounds} = TimeBounds.new(min_time: 0, max_time: "123")
  end

  test "set_timeout/1" do
    %TimeBounds{min_time: 0, max_time: 123} = TimeBounds.set_timeout(123)
  end

  test "set_timeout/1 with_invalid_value" do
    {:error, :invalid_time_bounds} = TimeBounds.set_timeout("123")
  end

  test "to_xdr/1" do
    %OptionalTimeBounds{time_bounds: nil} = TimeBounds.new() |> TimeBounds.to_xdr()
  end

  test "to_xdr/1 with_values" do
    min_time = TimePoint.new(123)
    max_time = TimePoint.new(456)
    time_bounds = TimeBoundsXDR.new(min_time, max_time)

    %OptionalTimeBounds{time_bounds: ^time_bounds} =
      TimeBounds.new(min_time: 123, max_time: 456) |> TimeBounds.to_xdr()
  end
end
