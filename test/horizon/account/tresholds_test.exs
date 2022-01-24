defmodule Stellar.Horizon.Account.ThresholdsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Account.Thresholds

  setup do
    %{
      attrs: %{
        low_threshold: 0,
        med_threshold: 1,
        high_threshold: 2
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %Thresholds{
      low_threshold: 0,
      med_threshold: 1,
      high_threshold: 2
    } = Thresholds.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Thresholds{low_threshold: 0, med_threshold: 0, high_threshold: 0} = Thresholds.new(%{})
  end
end
