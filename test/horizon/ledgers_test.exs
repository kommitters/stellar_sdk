defmodule Stellar.Horizon.Client.CannedLedgerRequests do
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
  def request(:get, @base_url <> "/ledgers/10", _headers, _body, _opts) do
    json_body = Horizon.fixture("ledger")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/ledgers/not_found", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(:get, @base_url <> "/ledgers/10/effects" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("effects")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/ledgers/10/transactions" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("transactions")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/ledgers/10/operations" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("operations")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/ledgers/10/payments" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("payments")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/ledgers?cursor=5404056700846080" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :next})
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/ledgers?cursor=5404065290780672" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/ledgers" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("ledgers")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.LedgersTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedLedgerRequests

  alias Stellar.Horizon.{
    Collection,
    Effect,
    Error,
    Ledger,
    Ledgers,
    Operation,
    Transaction
  }

  alias Stellar.Horizon.Operation.{CreateAccount, Payment, SetOptions}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedLedgerRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{ledger_sequence: 10}
  end

  test "retrieve/1", %{ledger_sequence: ledger_sequence} do
    {:ok,
     %Ledger{
       base_fee_in_stroops: 100,
       base_reserve_in_stroops: 100_000_000,
       closed_at: ~U[2015-09-30 17:16:29Z],
       failed_transaction_count: 0,
       fee_pool: "0.0000300",
       hash: "31c33314a9d6f1d1e07040029f56403fc410829a45dfe9cc662c6b2dce8f53b3",
       header_xdr: "AAAAAdofgbAA===",
       id: "31c33314a9d6f1d1e07040029f56403fc410829a45dfe9cc662c6b2dce8f53b3",
       max_tx_set_size: 500,
       operation_count: 0,
       paging_token: "42949672960",
       prev_hash: "da0516f96a9d3a00e8f60c60307cad062021cbad3c99f72ad8e277803dece482",
       protocol_version: 1,
       sequence: 10,
       successful_transaction_count: 0,
       total_coins: "100000000000.0000000",
       tx_set_operation_count: 0
     }} = Ledgers.retrieve(ledger_sequence)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Ledger{
           hash: "29b15176e88b828c219ab75760a2e3abe052c16f1c34d069320c7591a4bd7a77",
           sequence: 1_258_232,
           protocol_version: 18
         },
         %Ledger{
           hash: "ea3f21f0748f52fe700317971c46bca873b8cf6eb92296ea23d5a9416c455578",
           sequence: 1_258_231,
           protocol_version: 18
         },
         %Ledger{
           hash: "b05802d4c9f132d6ec0bb60defd0a0e5b41c1ccdcc52849fbad0725d83a54b77",
           sequence: 1_258_230,
           protocol_version: 18
         }
       ]
     }} = Ledgers.all()
  end

  test "list_transactions/1", %{ledger_sequence: ledger_sequence} do
    {:ok,
     %Collection{
       records: [
         %Transaction{
           id: "3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889",
           ledger: 7840
         },
         %Transaction{
           id: "2db4b22ca018119c5027a80578813ffcf582cda4aa9e31cd92b43cf1bda4fc5a",
           ledger: 7841
         },
         %Transaction{
           id: "3ce2aca2fed36da2faea31352c76c5e412348887a4c119b1e90de8d1b937396a",
           ledger: 7855
         }
       ]
     }} = Ledgers.list_transactions(ledger_sequence, limit: 3, order: :asc)
  end

  test "list_operations/1", %{ledger_sequence: ledger_sequence} do
    {:ok,
     %Collection{
       records: [
         %Operation{
           body: %SetOptions{},
           type: "set_options",
           type_i: 5
         },
         %Operation{
           body: %Payment{},
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %CreateAccount{},
           type: "create_account",
           type_i: 0
         }
       ]
     }} = Ledgers.list_operations(ledger_sequence, limit: 3, order: :desc)
  end

  test "list_payments/1", %{ledger_sequence: ledger_sequence} do
    {:ok,
     %Collection{
       records: [
         %Operation{
           body: %Payment{amount: "0.0000001"},
           type: "payment"
         },
         %Operation{
           body: %Payment{amount: "1.0000000"},
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %Payment{amount: "1.0000000"},
           type: "payment",
           type_i: 1
         }
       ]
     }} = Ledgers.list_payments(ledger_sequence, limit: 3)
  end

  test "list_effects/1", %{ledger_sequence: ledger_sequence} do
    {:ok,
     %Collection{
       records: [
         %Effect{type: "account_created", created_at: ~U[2015-09-30 17:15:54Z]},
         %Effect{type: "account_debited", created_at: ~U[2015-09-30 17:16:54Z]},
         %Effect{type: "signer_created", created_at: ~U[2015-09-30 17:17:54Z]}
       ]
     }} = Ledgers.list_effects(ledger_sequence, limit: 3)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Ledgers.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Ledgers.all(limit: 3)
    paginate_next_fn.()

    assert_receive({:paginated, :next})
  end

  test "error" do
    {:error,
     %Error{
       extras: nil,
       status_code: 404,
       title: "Resource Missing",
       type: "https://stellar.org/horizon-errors/not_found"
     }} = Ledgers.retrieve("not_found")
  end
end
