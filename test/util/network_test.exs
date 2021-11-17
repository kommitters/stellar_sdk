defmodule Stellar.NetworkTest do
  use ExUnit.Case

  alias Stellar.Network

  @test_network_url "https://horizon-testnet.stellar.org"
  @test_passphrase "Test SDF Network ; September 2015"

  @public_network_url "https://horizon.stellar.org"
  @public_passphrase "Public Global Stellar Network ; September 2015"

  test "base_url/0" do
    @test_network_url = Network.base_url()
  end

  test "passphrase/0" do
    @test_passphrase = Network.passphrase()
  end

  test "current/0" do
    :test = Network.current()
  end

  describe "config/0" do
    setup do
      on_exit(fn -> Application.put_env(:stellar_sdk, :network, :test) end)
      Application.put_env(:stellar_sdk, :network, :public)
    end

    test "base_url/0" do
      @public_network_url = Network.base_url()
    end

    test "passphrase/0" do
      @public_passphrase = Network.passphrase()
    end

    test "current/0" do
      :public = Network.current()
    end
  end
end
