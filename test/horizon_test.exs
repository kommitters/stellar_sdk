defmodule StellarSDK.HorizonTest do
  use ExUnit.Case, async: true

  import Mox

  alias StellarSDK.Horizon
  alias StellarSDK.Horizon.{HackneyMock, HTTPoitionMock}

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  @network_url "https://horizon.stellar.org"
  @network_passphrase "Public Global Stellar Network ; September 2015"

  setup do
    %{
      body: ~s<{"_embedded": { "records": [] }}>,
      body_404: ~s<{"status": 404, "title": "Resource Missing"}>,
      headers: [{"Content-Type", "application/hal+json; charset=utf-8"}]
    }
  end

  describe "request/5" do
    setup do
      on_exit(fn -> Application.put_env(:stellar_sdk, :network, :test) end)
    end

    test "success", %{body: body, headers: headers} do
      HackneyMock
      |> expect(:request, fn _method, _url, _body, _headers, _opts ->
        {:ok,
         %{
           status_code: 200,
           body: body,
           headers: headers
         }}
      end)

      {:ok, %{status_code: 200, body: ^body}} = Horizon.request(:get, "/accounts/id")
    end

    test "not_found", %{body: body_404, headers: headers} do
      HackneyMock
      |> expect(:request, fn _method, _url, _body, _headers, _opts ->
        {:ok,
         %{
           status_code: 404,
           headers: headers,
           body: body_404
         }}
      end)

      {:ok, %{status_code: 404, body: ^body_404}} = Horizon.request(:get, "/accounts/unknow_id")
    end

    test "error" do
      expect(HackneyMock, :request, fn _method, _url, _body, _headers, _opts ->
        {:error, %{reason: "reason"}}
      end)

      {:error, %{reason: "reason"}} = Horizon.request(:delete, "/accounts")
    end
  end

  describe "configuration" do
    setup do
      on_exit(fn -> Application.put_env(:stellar_sdk, :network, :test) end)
    end

    test "config/0" do
      Application.put_env(:stellar_sdk, :network, :public)

      [network: :public, url: @network_url, passphrase: @network_passphrase] =
        StellarSDK.Horizon.network_config()
    end

    test "config/1" do
      Application.put_env(:stellar_sdk, :network, :public)

      assert StellarSDK.Horizon.network_config(:url) == @network_url
      assert StellarSDK.Horizon.network_config(:passphrase) == @network_passphrase
    end
  end

  describe "custom HTTP client" do
    setup do
      on_exit(fn -> Application.put_env(:stellar_sdk, :http_client, HackneyMock) end)
    end

    test "request/5", %{body: body} do
      Application.put_env(:stellar_sdk, :http_client, HTTPoitionMock)

      HTTPoitionMock
      |> expect(:request, fn _method, _url, _body, _headers, _opts ->
        {:ok, %{code: 200, body: body}}
      end)

      {:ok, %{code: 200, body: ^body}} = Horizon.request(:get, "/accounts/id")
    end
  end
end
