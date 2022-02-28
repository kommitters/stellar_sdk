defmodule Stellar.Horizon.Client.CannedRequestImpl do
  @moduledoc false

  @behaviour Stellar.Horizon.Client.Spec

  @impl true
  def request(_method, "/transactions/f08b8/effects" <> _query, _headers, _body, _opts) do
    send(self(), {:horizon_requested, 200})
    {:ok, 200, [], nil}
  end
end

defmodule Stellar.Horizon.RequestTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Client.CannedRequestImpl
  alias Stellar.Horizon.{Collection, Error, Request, Transaction}

  setup do
    Application.put_env(:stellar_sdk, :http_client_impl, CannedRequestImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client_impl)
    end)

    endpoint = "transactions"
    hash = "f08b83906eaebfbf359182cc1e47a0e5c4bbdbad1a897785d5677a2bfc54b5b1"
    body = [tx: "AAAAAgAAABAAAAAAAAAA==="]
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    query = [cursor: "549755817992-1", order: "desc", limit: 25]
    segment = "trades"
    segment_path = "0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434"

    %{
      endpoint: endpoint,
      hash: hash,
      segment: segment,
      segment_path: segment_path,
      body: body,
      headers: headers,
      query: query
    }
  end

  test "new/1", %{endpoint: endpoint, hash: hash} do
    %Request{method: :get, endpoint: ^endpoint, path: ^hash, body: [], headers: [], query: []} =
      Request.new(:get, endpoint, path: hash)
  end

  test "new/1 with_segment", %{
    endpoint: endpoint,
    hash: hash,
    segment: segment,
    segment_path: segment_path
  } do
    %Request{
      method: :get,
      endpoint: ^endpoint,
      path: ^hash,
      segment: ^segment,
      segment_path: ^segment_path,
      body: [],
      headers: [],
      query: []
    } = Request.new(:get, endpoint, path: hash, segment: segment, segment_path: segment_path)
  end

  test "add_body/2", %{endpoint: endpoint, body: body} do
    %Request{method: :post, endpoint: ^endpoint, body: ^body} =
      :post
      |> Request.new(endpoint)
      |> Request.add_body(body)
  end

  test "add_headers/2", %{endpoint: endpoint, headers: headers} do
    %Request{method: :post, endpoint: ^endpoint, headers: ^headers} =
      :post
      |> Request.new(endpoint)
      |> Request.add_headers(headers)
  end

  test "add_query/3", %{endpoint: endpoint, query: query} do
    %Request{
      method: :get,
      endpoint: ^endpoint,
      query: ^query,
      encoded_query: "cursor=549755817992-1&order=desc&limit=25"
    } =
      :get
      |> Request.new(endpoint)
      |> Request.add_query(query)
  end

  test "add_query/3 extra_params", %{endpoint: endpoint, query: query} do
    query = query ++ [include_failed: true]

    %Request{
      method: :get,
      endpoint: ^endpoint,
      query: ^query,
      encoded_query: "cursor=549755817992-1&order=desc&limit=25&include_failed=true"
    } =
      :get
      |> Request.new(endpoint)
      |> Request.add_query(query, extra_params: [:include_failed])
  end

  test "add_query/3 invalid_params", %{endpoint: endpoint} do
    %Request{
      method: :get,
      endpoint: ^endpoint,
      encoded_query: "cursor=549755817992-1"
    } =
      :get
      |> Request.new(endpoint)
      |> Request.add_query([cursor: "549755817992-1", test: "test"],
        extra_params: [:include_failed]
      )
  end

  test "perform/2" do
    :get
    |> Request.new("transactions", path: "f08b8", segment: "effects", segment_path: "123")
    |> Request.add_query(limit: 10)
    |> Request.perform()

    assert_receive({:horizon_requested, 200})
  end

  test "results/2 success" do
    body = Horizon.fixture("transaction")
    transaction = Jason.decode!(body, keys: :atoms)

    {:ok,
     %Transaction{
       hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
       ledger: 27_956_256
     }} = Request.results({:ok, transaction}, &Transaction.new(&1))
  end

  test "results/2 collection" do
    body = Horizon.fixture("transactions")
    transactions = Jason.decode!(body, keys: :atoms)

    {:ok,
     %Collection{
       records: [
         %Transaction{hash: "3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889"},
         %Transaction{hash: "2db4b22ca018119c5027a80578813ffcf582cda4aa9e31cd92b43cf1bda4fc5a"},
         %Transaction{hash: "3ce2aca2fed36da2faea31352c76c5e412348887a4c119b1e90de8d1b937396a"}
       ],
       next:
         "https://horizon.stellar.org/transactions?cursor=33736968114176\u0026limit=3\u0026order=asc",
       prev:
         "https://horizon.stellar.org/transactions?cursor=12884905984\u0026limit=3\u0026order=desc",
       self: "https://horizon.stellar.org/transactions?cursor=\u0026limit=3\u0026order=asc"
     }} = Request.results({:ok, transactions}, &Collection.new({Transaction, &1}))
  end

  test "results/2 error" do
    {:error, %Error{}} = Request.results({:error, %Error{}}, &Collection.new({Transaction, &1}))
  end
end
