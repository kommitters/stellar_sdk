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
  def request(:post, @base_url <> "/transactions/", _headers, "tx=bad", _opts) do
    json_error = Horizon.fixture("400")
    {:ok, 400, [], json_error}
  end

  def request(:post, @base_url <> "/transactions/", _headers, "tx=" <> _hash, _opts) do
    json_body = Horizon.fixture("transaction")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.TransactionsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedTransactionRequests
  alias Stellar.Horizon.{Error, Transaction, Transactions}

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

  describe "create/1" do
    test "success", %{base64_envelope: base64_envelope, hash: hash} do
      {:ok, %Transaction{successful: true, envelope_xdr: ^base64_envelope, hash: ^hash}} =
        Transactions.create(base64_envelope)
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
end
