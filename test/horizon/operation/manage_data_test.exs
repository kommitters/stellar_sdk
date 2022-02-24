defmodule Stellar.Horizon.Operation.ManageDataTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.ManageData

  setup do
    %{
      attrs: %{
        name: "config.memo_required",
        value: "MQ=="
      }
    }
  end

  test "new/2", %{attrs: %{name: name, value: value} = attrs} do
    %ManageData{name: ^name, value: ^value} = ManageData.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ManageData{name: nil, value: nil} = ManageData.new(%{})
  end
end
