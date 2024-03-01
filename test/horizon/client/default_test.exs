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
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, atom()}
  def request(:get, @base_url <> "/transactions/" <> _hash, _headers, _body, _opts) do
    json_body = Horizon.fixture("200")
    {:ok, 200, [], json_body}
  end

  def request(:post, @base_url <> "/transactions?tx=bad", _headers, _body, _opts) do
    json_error = Horizon.fixture("400_invalid_tx")
    {:ok, 400, [], json_error}
  end

  def request(:get, @base_url <> "/accounts/unknown_id", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(:get, @base_url <> "/accounts/id.html", _headers, _body, _opts) do
    json_error = Horizon.fixture("406")
    {:ok, 406, [], json_error}
  end

  def request(:get, @base_url <> "/accounts?cursor=old", _headers, _body, _opts) do
    json_error = Horizon.fixture("410")
    {:ok, 410, [], json_error}
  end

  def request(:post, @base_url <> "/transactions?tx=stale", _headers, _body, _opts) do
    json_error = Horizon.fixture("503")
    {:ok, 503, [], json_error}
  end

  def request(:post, @base_url <> "/transactions?tx=timeout", _headers, _body, _opts) do
    json_error = Horizon.fixture("504")
    {:ok, 504, [], json_error}
  end

  def request(:post, @base_url <> "/network_error", _headers, _body, _opts) do
    {:error, :nxdomain}
  end
end

defmodule Stellar.Horizon.Client.DefaultTest do
  use ExUnit.Case

  alias Stellar.Horizon.{Error, Server}
  alias Stellar.Horizon.Client.{Default, CannedHTTPClient}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedHTTPClient)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      source_account: "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC",
      tx_hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
      server: Server.testnet()
    }
  end

  describe "request/5" do
    test "success", %{source_account: source_account, tx_hash: tx_hash, server: server} do
      {:ok, %{source_account: ^source_account, hash: ^tx_hash}} =
        Default.request(server, :get, "/transactions/#{tx_hash}")
    end

    test "bad_request", %{server: server} do
      {:error, %Error{title: "Transaction Failed", status_code: 400}} =
        Default.request(server, :post, "/transactions?tx=bad")
    end

    test "not_found", %{server: server} do
      {:error, %Error{title: "Resource Missing", status_code: 404}} =
        Default.request(server, :get, "/accounts/unknown_id")
    end

    test "not_acceptable", %{server: server} do
      {:error, %Error{title: "Not Acceptable", status_code: 406}} =
        Default.request(server, :get, "/accounts/id.html")

    end

    test "before_history", %{server: server} do
      {:error, %Error{title: "Data Requested Is Before Recorded History", status_code: 410}} =
        Default.request(server, :get, "/accounts?cursor=old")
    end

    test "stale_history", %{server: server} do
      {:error, %Error{title: "Historical DB Is Too Stale", status_code: 503}} =
        Default.request(server, :post, "/transactions?tx=stale")
    end

    test "timeout", %{server: server} do
      {:error, %Error{title: "Timeout", status_code: 504}} =
        Default.request(server, :post, "/transactions?tx=timeout")
    end

    test "network_error", %{server: server} do
      {:error, %Error{title: "Network error", status_code: :network_error}} =
        Default.request(server, :post, "/network_error")
    end
  end
end
