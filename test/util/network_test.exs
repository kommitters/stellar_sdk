defmodule Stellar.NetworkTest do
  use ExUnit.Case

  alias Stellar.Network

  @public_passphrase "Public Global Stellar Network ; September 2015"
  @testnet_passphrase "Test SDF Network ; September 2015"
  @futurenet_passphrase "Test SDF Future Network ; October 2022"
  @standalone_passphrase "Standalone Network ; February 2017"

  @public_horizon_url "https://horizon.stellar.org"
  @testnet_horizon_url "https://horizon-testnet.stellar.org"
  @futurenet_horizon_url "https://horizon-futurenet.stellar.org"
  @local_horizon_url "http://localhost:8000"

  describe "network passphrases" do
    test "public_passphrase/0" do
      @public_passphrase = Network.public_passphrase()
    end

    test "testnet_passphrase/0" do
      @testnet_passphrase = Network.testnet_passphrase()
    end

    test "futurenet_passphrase/0" do
      @futurenet_passphrase = Network.futurenet_passphrase()
    end

    test "standalone_passphrase/0" do
      @standalone_passphrase = Network.standalone_passphrase()
    end
  end

  describe "network horizon urls" do
    test "public_horizon_url/0" do
      @public_horizon_url = Network.public_horizon_url()
    end

    test "testnet_horizon_url/0" do
      @testnet_horizon_url = Network.testnet_horizon_url()
    end

    test "futurenet_horizon_url/0" do
      @futurenet_horizon_url = Network.futurenet_horizon_url()
    end

    test "local_horizon_url/0" do
      @local_horizon_url = Network.local_horizon_url()
    end
  end
end
