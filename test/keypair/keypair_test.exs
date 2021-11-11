defmodule Stellar.KeyPair.CannedKeyPairImpl do
  @moduledoc false

  @behaviour Stellar.KeyPair.Spec

  @impl true
  def random do
    send(self(), {:random, "KEY"})
    :ok
  end

  @impl true
  def from_secret(_secret) do
    send(self(), {:secret, "SECRET"})
    :ok
  end
end

defmodule Stellar.KeyPairTest do
  use ExUnit.Case

  test "random/0" do
    Stellar.KeyPair.random()
    assert_receive({:random, "KEY"})
  end

  test "from_secret/1" do
    Stellar.KeyPair.from_secret("SECRET")
    assert_receive({:secret, "SECRET"})
  end
end
