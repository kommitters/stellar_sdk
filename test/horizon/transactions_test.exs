defmodule Stellar.Horizon.Client.CannedTransactionRequests do
  @moduledoc false

  alias Stellar.Horizon.Error
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
          "/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/effects?" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("effects")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/operations?" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("operations")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/transactions/" <> _hash, _headers, _body, _opts) do
    json_body = Horizon.fixture("transaction")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/transactions?cursor=33736968114176&limit=" <> _limit,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("transactions")
    {:ok, 200, [], json_body}
  end

  def request(:post, @base_url <> "/transactions", _headers, "tx=bad", _opts) do
    json_error = Horizon.fixture("400")
    {:ok, 400, [], json_error}
  end

  def request(:post, @base_url <> "/transactions", _headers, "tx=" <> _envelope, _opts) do
    json_body = Horizon.fixture("transaction")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.TransactionsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedTransactionRequests
  alias Stellar.Horizon.{Collection, Effect, Error, Operation, Transaction, Transactions}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedTransactionRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      base64_envelope:
        "AAAAAJ2kP2xLaOVLj6DRwX1mMyA0mubYnYvu0g8OdoDqxXuFAAAAZADjfzAACzBMAAAAAQAAAAAAAAAAAAAAAF4vYIYAAAABAAAABjI5ODQyNAAAAAAAAQAAAAAAAAABAAAAAKdeYELovtcnTxqPEVsdbxHLMoMRalZsK7lo/+3ARzUZAAAAAAAAAADUFJPYAAAAAAAAAAHqxXuFAAAAQBpLpQyh+mwDd5nDSxTaAh5wopBBUaSD1eOK9MdiO+4kWKVTqSr/Ko3kYE/+J42Opsewf81TwINONPbY2CtPggE=",
      hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31"
    }
  end

  test "create/1", %{base64_envelope: base64_envelope, hash: hash} do
    {:ok, %Transaction{successful: true, envelope_xdr: ^base64_envelope, hash: ^hash}} =
      Transactions.create(base64_envelope)
  end

  test "retrieve/1", %{hash: hash} do
    {:ok, %Transaction{hash: ^hash}} = Transactions.retrieve(hash)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Transaction{
           hash: "3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889"
         },
         %Transaction{
           hash: "2db4b22ca018119c5027a80578813ffcf582cda4aa9e31cd92b43cf1bda4fc5a"
         },
         %Transaction{
           hash: "3ce2aca2fed36da2faea31352c76c5e412348887a4c119b1e90de8d1b937396a"
         }
       ],
       next:
         "https://horizon.stellar.org/transactions?cursor=33736968114176\u0026limit=3\u0026order=asc"
     }} = Transactions.all(cursor: "33736968114176", limit: 3)
  end

  test "list_effects/2", %{hash: hash} do
    {:ok,
     %Collection{
       records: [
         %Effect{type: "account_created"},
         %Effect{type: "account_debited"},
         %Effect{type: "signer_created"}
       ]
     }} = Transactions.list_effects(hash, limit: 3)
  end

  test "list_operations/2", %{hash: hash} do
    {:ok,
     %Collection{
       next:
         "https://horizon.stellar.org/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/operations?cursor=12884905985&limit=3&order=desc",
       records: [
         %Operation{type: "set_options"},
         %Operation{type: "payment"},
         %Operation{type: "create_account"}
       ]
     }} = Transactions.list_operations(hash, limit: 3, order: :desc)
  end

  test "error" do
    {:error,
     %Error{
       status_code: 400,
       title: "Transaction Failed",
       extras: %{result_codes: %{transaction: "tx_insufficient_fee"}}
     }} = Transactions.create("bad")
  end
end
