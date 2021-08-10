defmodule StellarSDKTest do
  use ExUnit.Case
  doctest StellarSDK

  test "greets the world" do
    assert StellarSDK.hello() == :world
  end
end
