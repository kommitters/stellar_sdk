defmodule Stellar.Horizon.Account.DataTest do
  use ExUnit.Case

  alias Stellar.Horizon.Account.Data

  setup do
    %{attrs: %{value: "MQ=="}}
  end

  test "new/2", %{attrs: attrs} do
    %Data{value: "MQ=="} = Data.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Data{value: nil} = Data.new(%{})
  end
end
