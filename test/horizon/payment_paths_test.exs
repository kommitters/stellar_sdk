defmodule Stellar.Horizon.Client.CannedPathRequests do
  alias Stellar.Test.Fixtures.Horizon

  @base_url "https://horizon-testnet.stellar.org"

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          options :: list()
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, atom()}

  def request(
        :get,
        @base_url <>
          "/paths?source_account=GBTKSXOTFMC5HR25SNL76MOVQW7GA3F6CQEY622ASLUV4VMLITI6TCOO&destination_asset_type=native&destination_amount=5",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("paths")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/paths/strict-receive?destination_asset_type=native&destination_amount=5&source_account=GBTKSXOTFMC5HR25SNL76MOVQW7GA3F6CQEY622ASLUV4VMLITI6TCOO",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("paths")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/paths/strict-send?source_asset_type=native&source_amount=5&destination_assets=TEST%3AGA654JC6QLA3ZH4O5V7X5NPM7KEWHKRG5GJA4PETK4SOFBUJLCCN74KQ",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("paths")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/paths/strict-receive?destination_amount=error",
        _headers,
        _body,
        _opts
      ) do
    json_error = Horizon.fixture("400_invalid_receive_path")
    {:ok, 400, [], json_error}
  end

  def request(:get, @base_url <> "/paths/strict-send?source_amount=error", _headers, _body, _opts) do
    json_error = Horizon.fixture("400_invalid_send_path")
    {:ok, 400, [], json_error}
  end
end

defmodule Stellar.Horizon.PaymentPathsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedPathRequests
  alias Stellar.Horizon.{Path, Paths, PaymentPaths, Error}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedPathRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      source_account: "GBTKSXOTFMC5HR25SNL76MOVQW7GA3F6CQEY622ASLUV4VMLITI6TCOO",
      destination_asset_type: :native,
      destination_amount: 5,
      destination_assets: "TEST:GA654JC6QLA3ZH4O5V7X5NPM7KEWHKRG5GJA4PETK4SOFBUJLCCN74KQ",
      source_asset_type: :native,
      source_amount: 5
    }
  end

  test "list_paths/1", %{
    source_account: source_account,
    destination_asset_type: destination_asset_type,
    destination_amount: destination_amount
  } do
    {:ok,
     %Paths{
       records: [
         %Path{
           destination_amount: 5.0,
           destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           source_amount: 28.9871131
         },
         %Path{
           destination_amount: 5.0,
           destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           source_amount: 29.0722784
         }
       ]
     }} =
      PaymentPaths.list_paths(
        source_account: source_account,
        destination_asset_type: destination_asset_type,
        destination_amount: destination_amount
      )
  end

  test "list_receive_paths/1", %{
    source_account: source_account,
    destination_asset_type: destination_asset_type,
    destination_amount: destination_amount
  } do
    {:ok,
     %Paths{
       records: [
         %Path{
           destination_asset_code: "BB1",
           destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           destination_asset_type: "credit_alphanum4"
         },
         %Path{
           destination_asset_code: "BB1",
           destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
           destination_asset_type: "credit_alphanum4"
         }
       ]
     }} =
      PaymentPaths.list_receive_paths(
        destination_asset_type: destination_asset_type,
        destination_amount: destination_amount,
        source_account: source_account
      )
  end

  test "list_send_paths/1", %{
    source_asset_type: source_asset_type,
    source_amount: source_amount,
    destination_assets: destination_assets
  } do
    {:ok,
     %Paths{
       records: [
         %Stellar.Horizon.Path{
           destination_amount: 5.0,
           path: [
             %{
               asset_code: "XCN",
               asset_issuer: "GCNY5OXYSY4FKHOPT2SPOQZAOEIGXB5LBYW3HVU3OWSTQITS65M5RCNY",
               asset_type: "credit_alphanum4"
             },
             %{asset_type: "native"}
           ]
         },
         %Stellar.Horizon.Path{
           destination_amount: 5.0,
           path: [
             %{
               asset_code: "ULT",
               asset_issuer: "GC76RMFNNXBFDSJRBXCABWLHXDK4ITVQSMI56DC2ZJVC3YOLLPCKKULT",
               asset_type: "credit_alphanum4"
             },
             %{asset_type: "native"}
           ]
         }
       ]
     }} =
      PaymentPaths.list_send_paths(
        source_asset_type: source_asset_type,
        source_amount: source_amount,
        destination_assets: destination_assets
      )
  end

  test "list strict receive error" do
    {:error,
     %Error{
       detail: "The request you sent was invalid in some way.",
       extras: %{invalid_field: "destination_asset_type", reason: "Missing required field"},
       status_code: 400,
       title: "Bad Request"
     }} = PaymentPaths.list_receive_paths(destination_amount: "error")
  end

  test "list strict send error" do
    {:error,
     %Error{
       detail: "The request you sent was invalid in some way.",
       extras: %{invalid_field: "source_asset_type", reason: "Missing required field"},
       status_code: 400,
       title: "Bad Request"
     }} = PaymentPaths.list_send_paths(source_amount: "error")
  end
end
