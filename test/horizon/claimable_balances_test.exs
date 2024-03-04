defmodule Stellar.Horizon.Client.CannedClaimableBalanceRequests do
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
          "/claimable_balances/00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("claimable_balance")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/claimable_balances/not_found", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(
        :get,
        @base_url <>
          "/claimable_balances/00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072/transactions" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("transactions")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/claimable_balances/00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072/operations" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("operations")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/claimable_balances?sponsor=" <> _sponsor,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("claimable_balances")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/claimable_balances?claimant=" <> _claimant,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("claimable_balances")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/claimable_balances?asset=" <> _asset, _headers, _body, _opts) do
    json_body = Horizon.fixture("claimable_balances")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/claimable_balances?cursor=1268715-0000000032d73407ea08b122407e32833cc6f9f6dc72ee0dd01e482fa06fdfadc32d01ea" <>
          _query,
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
        @base_url <>
          "/claimable_balances?cursor=1269595-00000000d6575278b432b3ee4e07cc0b17721fafc32c3b5c1403be68d8309268e91e585f" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/claimable_balances" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("claimable_balances")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.ClaimableBalancesTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedClaimableBalanceRequests

  alias Stellar.Horizon.{
    ClaimableBalance,
    ClaimableBalances,
    Collection,
    Error,
    Operation,
    Transaction,
    Server
  }

  alias Stellar.Horizon.Operation.{CreateAccount, Payment, SetOptions}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedClaimableBalanceRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      claimable_balance_id:
        "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    }
  end

  test "retrieve/1", %{claimable_balance_id: claimable_balance_id} do
    {:ok,
     %ClaimableBalance{
       amount: "10.0000000",
       asset: "native",
       claimants: [
         %{
           destination: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML",
           predicate: %{
             and: [
               %{
                 or: [
                   %{relBefore: "12"},
                   %{
                     absBefore: "2020-08-26T11:15:39Z",
                     absBeforeEpoch: "1598440539"
                   }
                 ]
               },
               %{not: %{unconditional: true}}
             ]
           }
         }
       ],
       id: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
       last_modified_ledger: 28_411_995,
       last_modified_time: ~U[2020-02-26 19:29:16Z],
       paging_token: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
       sponsor: nil
     }} = ClaimableBalances.retrieve(Server.testnet(), claimable_balance_id)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %ClaimableBalance{
           amount: "82.4190840",
           asset: "BTCN:GDGHQTCJ3SGFBWBHJGVRUFBRLZGS5VS52HEDH4GVPX5GZRJQAOW7ZM37",
           claimants: [
             %{
               destination: "GATBAGTTQLQ4VKZMXLINLS6M4F2PEXMAZCK5ZE5ES4B6A2DXNGCFRX54",
               predicate: %{
                 abs_before: "2001-09-09T01:46:40Z",
                 abs_before_epoch: "1000000000"
               }
             }
           ],
           id: "00000000d6575278b432b3ee4e07cc0b17721fafc32c3b5c1403be68d8309268e91e585f",
           last_modified_ledger: 1_269_595,
           last_modified_time: ~U[2022-03-02 14:39:20Z],
           sponsor: "GBXISGJYYKE6RUO6L6KXBUJ7FJU4CWF647FLQAT3TZ2Q47IZHXFNYKYH"
         },
         %ClaimableBalance{
           amount: "912.5569285",
           asset: "y00XLM:GDGHQTCJ3SGFBWBHJGVRUFBRLZGS5VS52HEDH4GVPX5GZRJQAOW7ZM37",
           claimants: [
             %{
               destination: "GATBAGTTQLQ4VKZMXLINLS6M4F2PEXMAZCK5ZE5ES4B6A2DXNGCFRX54",
               predicate: %{not: %{unconditional: true}}
             }
           ],
           id: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
           last_modified_ledger: 1_269_432,
           last_modified_time: ~U[2022-03-02 14:25:09Z],
           sponsor: "GBXISGJYYKE6RUO6L6KXBUJ7FJU4CWF647FLQAT3TZ2Q47IZHXFNYKYH"
         },
         %ClaimableBalance{
           amount: "0.0000001",
           asset: "OxCBQksBk:GB3A3CK64CZDZ63FZTVI3OKK7ZCD75YQCPA2EKHPDFD6ABKEQ3ESTWVV",
           claimants: [
             %{
               destination: "GASY6U7YOOQSBSWORHZ3QI4N46XHZUKEAKOP7XEZZ5XOFP5HMNV5CFZ6",
               predicate: %{unconditional: true}
             },
             %{
               destination: "GB3A3CK64CZDZ63FZTVI3OKK7ZCD75YQCPA2EKHPDFD6ABKEQ3ESTWVV",
               predicate: %{unconditional: true}
             }
           ],
           id: "0000000032d73407ea08b122407e32833cc6f9f6dc72ee0dd01e482fa06fdfadc32d01ea",
           last_modified_ledger: 1_268_715,
           last_modified_time: ~U[2022-03-02 13:22:04Z],
           sponsor: "GB3A3CK64CZDZ63FZTVI3OKK7ZCD75YQCPA2EKHPDFD6ABKEQ3ESTWVV"
         }
       ]
     }} = ClaimableBalances.all(Server.testnet())
  end

  test "list_by_sponsor/2" do
    {:ok,
     %Collection{
       records: [
         %ClaimableBalance{sponsor: "GBXISGJYYKE6RUO6L6KXBUJ7FJU4CWF647FLQAT3TZ2Q47IZHXFNYKYH"}
         | _claimable_balances
       ]
     }} =
      ClaimableBalances.list_by_sponsor(
        Server.testnet(),
        "GBXISGJYYKE6RUO6L6KXBUJ7FJU4CWF647FLQAT3TZ2Q47IZHXFNYKYH"
      )
  end

  test "list_by_claimant/2" do
    {:ok,
     %Collection{
       records: [
         %ClaimableBalance{
           claimants: [%{destination: "GATBAGTTQLQ4VKZMXLINLS6M4F2PEXMAZCK5ZE5ES4B6A2DXNGCFRX54"}]
         }
         | _claimable_balances
       ]
     }} =
      ClaimableBalances.list_by_claimant(
        Server.testnet(),
        "GATBAGTTQLQ4VKZMXLINLS6M4F2PEXMAZCK5ZE5ES4B6A2DXNGCFRX54"
      )
  end

  test "list_by_asset/1" do
    {:ok,
     %Collection{
       records: [
         %ClaimableBalance{asset: "BTCN:GDGHQTCJ3SGFBWBHJGVRUFBRLZGS5VS52HEDH4GVPX5GZRJQAOW7ZM37"}
         | _claimable_balances
       ]
     }} =
      ClaimableBalances.list_by_asset(
        Server.testnet(),
        "BTCN:GDGHQTCJ3SGFBWBHJGVRUFBRLZGS5VS52HEDH4GVPX5GZRJQAOW7ZM37"
      )
  end

  test "list_transactions/1", %{claimable_balance_id: claimable_balance_id} do
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
     }} =
      ClaimableBalances.list_transactions(Server.testnet(), claimable_balance_id,
        limit: 3,
        order: :asc
      )
  end

  test "list_operations/1", %{claimable_balance_id: claimable_balance_id} do
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
     }} =
      ClaimableBalances.list_operations(Server.testnet(), claimable_balance_id,
        limit: 3,
        order: :desc
      )
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = ClaimableBalances.all(Server.testnet(), limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = ClaimableBalances.all(Server.testnet(), limit: 3)
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
     }} = ClaimableBalances.retrieve(Server.testnet(), "not_found")
  end
end
