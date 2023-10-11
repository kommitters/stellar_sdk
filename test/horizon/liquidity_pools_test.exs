defmodule Stellar.Horizon.Client.CannedLiquidityPoolRequests do
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
          "/liquidity_pools/0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("liquidity_pool")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/liquidity_pools/not_found", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(
        :get,
        @base_url <>
          "/liquidity_pools/0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434/transactions" <>
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
          "/liquidity_pools/0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434/operations" <>
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
        @base_url <>
          "/liquidity_pools/0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434/effects" <>
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
          "/liquidity_pools/0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434/trades" <>
          _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("trades")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/liquidity_pools?cursor=fd498c395920d57156e86b2d52acd2bbbfc164836a204c73d3b64bec33874d38" <>
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
          "/liquidity_pools?cursor=fe6490f5e64f25e62df49a6a4b5542b8e5411e84c6d3158613abb2271824deb9" <>
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

  def request(:get, @base_url <> "/liquidity_pools" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("liquidity_pools")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.LiquidityPoolsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedLiquidityPoolRequests

  alias Stellar.Horizon.{
    Collection,
    Effect,
    Error,
    LiquidityPool,
    LiquidityPools,
    Operation,
    Trade,
    Transaction
  }

  alias Stellar.Horizon.Operation.{CreateAccount, Payment, SetOptions}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedLiquidityPoolRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{liquidity_pool_id: "0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434"}
  end

  test "retrieve/1", %{liquidity_pool_id: liquidity_pool_id} do
    {:ok,
     %LiquidityPool{
       fee_bp: 30,
       id: "0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434",
       last_modified_ledger: 39_767_560,
       last_modified_time: ~U[2022-02-24 11:48:09Z],
       paging_token: "0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434",
       reserves: [
         %{
           amount: "522256061.0743940",
           asset: "XAU:GB3OE4IBQTYQFZZS5RXQHE4IPQL7ONOFOSAIS2NFRNMJKZEAI3AAUT2A"
         },
         %{
           amount: "533666459.4045717",
           asset: "ERRES:GA6ZAQGLDUEODDUUD3UD6PUFJYABWQA26SG5RK6E6CZ6OMD6AZKK5QNF"
         }
       ],
       total_shares: "500000000.0000000",
       total_trustlines: 1,
       type: "constant_product"
     }} = LiquidityPools.retrieve(liquidity_pool_id)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %LiquidityPool{
           fee_bp: 30,
           id: "fe6490f5e64f25e62df49a6a4b5542b8e5411e84c6d3158613abb2271824deb9",
           last_modified_ledger: 1_137_275,
           last_modified_time: ~U[2022-02-22 13:30:09Z],
           reserves: [
             %{
               amount: "228.6851160",
               asset: "BTCN:GDGUZCQFXCLZ775VZH3YGWRUIBKD6XKDJEW3E7CE5COT4EO7A3W22YUX"
             }
             | _reserves1
           ],
           total_shares: "1.9800000",
           total_trustlines: 1,
           type: "constant_product"
         },
         %LiquidityPool{
           fee_bp: 30,
           id: "fdccc907a78a11e592c122144f702fdb093160c510c0f4327994d9be5d951092",
           last_modified_ledger: 384_280,
           last_modified_time: ~U[2022-01-07 18:19:08Z],
           reserves: [
             %{
               amount: "100005.0152960",
               asset: "DOLLAR:GCO7B6KEDWOBM5X642ZOTPYTYTTBZIGVGUED4ZSBILJOAU4XB7ISJBFF"
             }
             | _reserves2
           ],
           total_shares: "100000.0000000",
           total_trustlines: 1,
           type: "constant_product"
         },
         %LiquidityPool{
           fee_bp: 30,
           id: "fd498c395920d57156e86b2d52acd2bbbfc164836a204c73d3b64bec33874d38",
           last_modified_ledger: 973_360,
           last_modified_time: ~U[2022-02-12 14:16:51Z],
           reserves: [
             %{amount: "130.8900524", asset: "native"}
             | _reserves3
           ],
           total_shares: "180.8936510",
           total_trustlines: 4,
           type: "constant_product"
         }
       ]
     }} = LiquidityPools.all()
  end

  test "list_transactions/1", %{liquidity_pool_id: liquidity_pool_id} do
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
     }} = LiquidityPools.list_transactions(liquidity_pool_id, limit: 3, order: :asc)
  end

  test "list_operations/1", %{liquidity_pool_id: liquidity_pool_id} do
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
     }} = LiquidityPools.list_operations(liquidity_pool_id, limit: 3, order: :desc)
  end

  test "list_effects/1", %{liquidity_pool_id: liquidity_pool_id} do
    {:ok,
     %Collection{
       records: [
         %Effect{type: "account_created", created_at: ~U[2015-09-30 17:15:54Z]},
         %Effect{type: "account_debited", created_at: ~U[2015-09-30 17:16:54Z]},
         %Effect{type: "signer_created", created_at: ~U[2015-09-30 17:17:54Z]},
         %Effect{type: "contract_debited", created_at: ~U[2023-10-10 15:53:13Z]},
         %Effect{type: "contract_credited", created_at: ~U[2023-10-10 15:52:40Z]}
       ]
     }} = LiquidityPools.list_effects(liquidity_pool_id, limit: 5)
  end

  test "list_trades/2", %{liquidity_pool_id: liquidity_pool_id} do
    {:ok,
     %Collection{
       records: [
         %Trade{base_amount: "4433.2000000"},
         %Trade{base_amount: "10.0000000"},
         %Trade{base_amount: "748.5338945"}
       ]
     }} = LiquidityPools.list_trades(liquidity_pool_id)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = LiquidityPools.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = LiquidityPools.all(limit: 3)
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
     }} = LiquidityPools.retrieve("not_found")
  end
end
