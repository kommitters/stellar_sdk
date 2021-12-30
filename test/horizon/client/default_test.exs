defmodule Stellar.Horizon.Client.CannedHTTPClient do
  @moduledoc false

  alias Stellar.Test.Fixtures.Horizon

  @base_url "https://horizon-testnet.stellar.org"

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          options :: list()
        ) :: {:ok, map()} | {:error, map()}
  def request(:get, @base_url <> "/transactions/unknow_id", _headers, _body, _opts) do
    json_error = Horizon.fixture(:not_found)
    {:ok, 404, [], json_error}
  end

  def request(:get, @base_url <> "/transactions/" <> _hash, _headers, _body, _opts) do
    json_body = Horizon.fixture(:transaction)
    {:ok, 200, [], json_body}
  end

  def request(:post, @base_url <> "/transactions?tx=bad", _headers, _body, _opts) do
    json_error = Horizon.fixture(:error)
    {:ok, 400, [], json_error}
  end

  def request(:post, @base_url <> "/network_error", _headers, _body, _opts) do
    {:error, :nxdomain}
  end
end

defmodule Stellar.Horizon.Client.DefaultTest do
  use ExUnit.Case

  alias Stellar.Horizon.Error
  alias Stellar.Horizon.Client.Default

  setup do
    %{
      source_account: "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC",
      tx_hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31"
    }
  end

  describe "request/5" do
    test "success", %{source_account: source_account, tx_hash: tx_hash} do
      {:ok, %{source_account: ^source_account, hash: ^tx_hash}} =
        Default.request(:get, "/transactions/#{tx_hash}")
    end

    test "not_found" do
      {:error, %Error{title: "Resource Missing", status_code: 404}} =
        Default.request(:get, "/transactions/unknow_id")
    end

    test "error" do
      {:error, %Error{title: "Transaction Failed", status_code: 400}} =
        Default.request(:post, "/transactions?tx=bad")
    end

    test "network_error" do
      {:error, %Error{title: "Network error", status_code: :network_error}} =
        Default.request(:post, "/network_error")
    end
  end
end
