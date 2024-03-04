defmodule Stellar.Horizon.Client.CannedTransactionRequests do
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
  def request(
        :get,
        @base_url <>
          "/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/effects" <>
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
          "/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/operations" <>
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
        @base_url <> "/transactions?limit=" <> _limit,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("transactions")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/transactions?cursor=12884905984&limit=3&order=desc",
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/transactions?cursor=33736968114176&limit=3&order=asc",
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :next})
    {:ok, 200, [], json_body}
  end

  def request(:post, @base_url <> "/transactions", _headers, "tx=bad", _opts) do
    json_error = Horizon.fixture("400_invalid_tx")
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

  alias Stellar.Horizon.{
    Collection,
    Effect,
    Error,
    Operation,
    Transaction,
    Transactions,
    Transaction.Preconditions,
    Transaction.TimeBounds,
    Transaction.LedgerBounds,
    Server
  }

  alias Stellar.Horizon.Operation.{CreateAccount, Payment, SetOptions}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedTransactionRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      source_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
      base64_envelope:
        "AAAAAJ2kP2xLaOVLj6DRwX1mMyA0mubYnYvu0g8OdoDqxXuFAAAAZADjfzAACzBMAAAAAQAAAAAAAAAAAAAAAF4vYIYAAAABAAAABjI5ODQyNAAAAAAAAQAAAAAAAAABAAAAAKdeYELovtcnTxqPEVsdbxHLMoMRalZsK7lo/+3ARzUZAAAAAAAAAADUFJPYAAAAAAAAAAHqxXuFAAAAQBpLpQyh+mwDd5nDSxTaAh5wopBBUaSD1eOK9MdiO+4kWKVTqSr/Ko3kYE/+J42Opsewf81TwINONPbY2CtPggE=",
      hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31"
    }
  end

  test "create/1", %{base64_envelope: base64_envelope, hash: hash} do
    {:ok, %Transaction{successful: true, envelope_xdr: ^base64_envelope, hash: ^hash}} =
      Transactions.create(Server.testnet(), base64_envelope)
  end

  test "retrieve/1", %{
    hash: hash,
    base64_envelope: base64_envelope,
    source_account: source_account
  } do
    {:ok,
     %Transaction{
       created_at: ~U[2020-01-27 22:13:17Z],
       envelope_xdr: ^base64_envelope,
       fee_charged: 100,
       hash: ^hash,
       id: ^hash,
       ledger: 27_956_256,
       max_fee: 100,
       memo: "298424",
       memo_type: "text",
       operation_count: 1,
       result_xdr: "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAA=",
       signatures: [
         "GkulDKH6bAN3mcNLFNoCHnCikEFRpIPV44r0x2I77iRYpVOpKv8qjeRgT/4njY6mx7B/zVPAg0409tjYK0+CAQ=="
       ],
       source_account: ^source_account,
       source_account_sequence: 64_034_663_849_209_932,
       successful: true,
       valid_after: ~U[1970-01-01 00:00:00Z],
       valid_before: ~U[2020-01-27 22:13:26Z],
       preconditions: %Preconditions{
         time_bounds: %TimeBounds{
           min_time: 0,
           max_time: 1_659_019_454
         },
         ledger_bounds: %LedgerBounds{
           min_ledger: 101_232,
           max_ledger: 3_123_123_213_123
         },
         min_account_sequence: 12_345,
         min_account_sequence_age: 4_567,
         min_account_sequence_ledger_gap: 78_910,
         extra_signers: [
           "GC7HDCY5A5Q6BJ466ABYJSZWPKQIWBPRHZMT3SUHW2YYDXGPZVS7I36S",
           "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
         ]
       }
     }} = Transactions.retrieve(Server.testnet(), hash)
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
       ]
     }} = Transactions.all(Server.testnet(), limit: 3)
  end

  test "list_effects/2", %{hash: hash} do
    {:ok,
     %Collection{
       records: [
         %Effect{type: "account_created", created_at: ~U[2015-09-30 17:15:54Z]},
         %Effect{type: "account_debited", created_at: ~U[2015-09-30 17:16:54Z]},
         %Effect{type: "signer_created", created_at: ~U[2015-09-30 17:17:54Z]},
         %Effect{type: "contract_debited", created_at: ~U[2023-10-10 15:53:13Z]},
         %Effect{type: "contract_credited", created_at: ~U[2023-10-10 15:52:40Z]}
       ]
     }} = Transactions.list_effects(Server.testnet(), hash, limit: 5)
  end

  test "list_operations/2", %{hash: hash, source_account: source_account} do
    {:ok,
     %Collection{
       records: [
         %Operation{
           body: %SetOptions{},
           source_account: ^source_account,
           type: "set_options",
           type_i: 5
         },
         %Operation{
           body: %Payment{},
           source_account: ^source_account,
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %CreateAccount{},
           source_account: ^source_account,
           type: "create_account",
           type_i: 0
         }
       ]
     }} = Transactions.list_operations(Server.testnet(), hash, limit: 3, order: :desc)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Transactions.all(Server.testnet(), limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Transactions.all(Server.testnet(), limit: 3)
    paginate_next_fn.()

    assert_receive({:paginated, :next})
  end

  test "error" do
    {:error,
     %Error{
       status_code: 400,
       title: "Transaction Failed",
       extras: %{result_codes: %{transaction: "tx_insufficient_fee"}}
     }} = Transactions.create(Server.testnet(), "bad")
  end
end
