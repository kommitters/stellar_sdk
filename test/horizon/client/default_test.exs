defmodule Stellar.Horizon.Client.CannedHTTPClient do
  @moduledoc false

  @base_url "https://horizon-testnet.stellar.org"

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          options :: list()
        ) :: {:ok, map()} | {:error, map()}
  def request(:get, @base_url <> "/accounts/unknow_id", _headers, _body, _opts) do
    {:ok, %{status_code: 404, body: ~s<{"status": 404, "title": "Resource Missing"}>}}
  end

  def request(:get, _path, _headers, _body, _opts) do
    {:ok, %{status_code: 200, body: ~s<{"_embedded": { "records": [] }}>}}
  end

  def request(:delete, _path, _headers, _body, _opts) do
    {:error, %{reason: "error"}}
  end
end

defmodule Stellar.Horizon.Client.DefaultTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.Default

  @network_url "https://horizon.stellar.org"
  @network_passphrase "Public Global Stellar Network ; September 2015"

  setup do
    %{
      body: ~s<{"_embedded": { "records": [] }}>,
      body_404: ~s<{"status": 404, "title": "Resource Missing"}>
    }
  end

  describe "request/5" do
    test "success", %{body: body} do
      {:ok, %{status_code: 200, body: ^body}} = Default.request(:get, "/accounts/id")
    end

    test "not_found", %{body_404: body} do
      {:ok, %{status_code: 404, body: ^body}} = Default.request(:get, "/accounts/unknow_id")
    end

    test "error" do
      {:error, %{reason: "error"}} = Default.request(:delete, "/accounts")
    end
  end

  describe "config/0" do
    setup do
      on_exit(fn -> Application.put_env(:stellar_sdk, :network, :test) end)
    end

    test "test" do
      :test = Default.config()[:network]
    end

    test "public" do
      Application.put_env(:stellar_sdk, :network, :public)

      [network: :public, url: @network_url, passphrase: @network_passphrase] = Default.config()
    end
  end
end
