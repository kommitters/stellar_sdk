defmodule Stellar.KeyPair.CannedKeyPairImpl do
  @moduledoc false

  @behaviour Stellar.KeyPair.Spec

  @impl true
  def random do
    send(self(), {:random, "KEY"})
    :ok
  end

  @impl true
  def from_secret_seed(_secret) do
    send(self(), {:secret, "SECRET"})
    :ok
  end

  @impl true
  def raw_public_key(_public_key) do
    send(self(), {:raw_public_key, "RAW_PUBLIC_KEY"})
    :ok
  end

  @impl true
  def raw_secret_seed(_secret) do
    send(self(), {:raw_secret, "RAW_SECRET"})
    :ok
  end

  @impl true
  def sign(_payload, _secret) do
    send(self(), {:signature, "SIGNATURE"})
    :ok
  end

  @impl true
  def validate_public_key(_public_key) do
    send(self(), {:ok, "PUBLIC_KEY"})
    :ok
  end

  @impl true
  def validate_secret_seed(_secret) do
    send(self(), {:ok, "SECRET_SEED"})
    :ok
  end
end

defmodule Stellar.KeyPairTest do
  use ExUnit.Case

  alias Stellar.KeyPair.CannedKeyPairImpl

  setup do
    Application.put_env(:stellar_sdk, :keypair_impl, CannedKeyPairImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :keypair_impl)
    end)
  end

  test "random/0" do
    Stellar.KeyPair.random()
    assert_receive({:random, "KEY"})
  end

  test "from_secret_seed/1" do
    Stellar.KeyPair.from_secret_seed("SECRET")
    assert_receive({:secret, "SECRET"})
  end

  test "raw_public_key/1" do
    Stellar.KeyPair.raw_public_key("RAW_PUBLIC_KEY")
    assert_receive({:raw_public_key, "RAW_PUBLIC_KEY"})
  end

  test "raw_secret_seed/1" do
    Stellar.KeyPair.raw_secret_seed("SECRET")
    assert_receive({:raw_secret, "RAW_SECRET"})
  end

  test "sign/2" do
    Stellar.KeyPair.sign(<<0, 0, 0, 0>>, "SECRET")
    assert_receive({:signature, "SIGNATURE"})
  end

  test "validate_public_key/1" do
    Stellar.KeyPair.validate_public_key("PUBLIC_KEY")
    assert_receive({:ok, "PUBLIC_KEY"})
  end

  test "validate_secret_seed/1" do
    Stellar.KeyPair.validate_secret_seed("SECRET_SEED")
    assert_receive({:ok, "SECRET_SEED"})
  end
end
