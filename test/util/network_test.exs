defmodule Stellar.NetworkTest do
  use ExUnit.Case

  alias Stellar.Network
  alias StellarBase.XDR.Hash

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

  describe "network ids" do
    setup do
      %{
        public_network_id:
          <<122, 195, 57, 151, 84, 78, 49, 117, 210, 102, 189, 2, 36, 57, 178, 44, 219, 22, 80,
            140, 1, 22, 63, 38, 229, 203, 42, 62, 16, 69, 169, 121>>,
        test_network_id:
          <<206, 224, 48, 45, 89, 132, 77, 50, 189, 202, 145, 92, 130, 3, 221, 68, 179, 63, 187,
            126, 220, 25, 5, 30, 163, 122, 190, 223, 40, 236, 212, 114>>
      }
    end

    test "network_id/1 for public network", %{public_network_id: public_network_id} do
      ^public_network_id = Network.network_id(@public_passphrase)
    end

    test "network_id_xdr/1 for public network", %{public_network_id: public_network_id} do
      %Hash{value: ^public_network_id} = Network.network_id_xdr(@public_passphrase)
    end

    test "network_id/1 for test network", %{test_network_id: test_network_id} do
      ^test_network_id = Network.network_id(@testnet_passphrase)
    end

    test "network_id_xdr/1 for test network", %{test_network_id: test_network_id} do
      %Hash{value: ^test_network_id} = Network.network_id_xdr(@testnet_passphrase)
    end
  end
end
