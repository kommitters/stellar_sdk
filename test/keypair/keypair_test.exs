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

  @impl true
  def raw_ed25519_public_key(_public_key) do
    send(self(), {:raw_public_key, "RAW_PUBLIC_KEY"})
    :ok
  end

  @impl true
  def raw_ed25519_secret(_secret) do
    send(self(), {:raw_secret, "RAW_SECRET"})
    :ok
  end

  @impl true
  def sign(_payload, _secret) do
    send(self(), {:signature, "SIGNATURE"})
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

  test "raw_ed25519_public_key/1" do
    Stellar.KeyPair.raw_ed25519_public_key("RAW_PUBLIC_KEY")
    assert_receive({:raw_public_key, "RAW_PUBLIC_KEY"})
  end

  test "raw_ed25519_secret/1" do
    Stellar.KeyPair.raw_ed25519_secret("SECRET")
    assert_receive({:raw_secret, "RAW_SECRET"})
  end

  test "sign/2" do
    Stellar.KeyPair.sign(<<0, 0, 0, 0>>, "SECRET")
    assert_receive({:signature, "SIGNATURE"})
  end
end
