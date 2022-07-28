defmodule Stellar.Horizon.Transaction.TimeBoundsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Transaction.TimeBounds

  setup do
    %{
      attrs: %{
        min_time: "0",
        max_time: "1659019454"
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %TimeBounds{
      min_time: 0,
      max_time: 1_659_019_454
    } = TimeBounds.new(attrs)
  end

  test "new/2 empty_attrs" do
    %TimeBounds{
      min_time: nil,
      max_time: nil
    } = TimeBounds.new(%{})
  end
end
