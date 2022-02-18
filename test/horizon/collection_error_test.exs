defmodule Stellar.Horizon.CollectionErrorTest do
  use ExUnit.Case

  alias Stellar.Horizon.CollectionError

  test "invalid_collection" do
    assert_raise CollectionError, "can't parse response as a collection", fn ->
      raise CollectionError, :invalid_collection
    end
  end

  test "error" do
    assert_raise CollectionError, "error", fn ->
      raise CollectionError, "error"
    end
  end
end
