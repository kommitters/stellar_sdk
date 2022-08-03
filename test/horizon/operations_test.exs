defmodule Stellar.Horizon.Client.CannedOperationRequests do
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
  def request(:get, @base_url <> "/operations/124624072438579201", _headers, _body, _opts) do
    json_body = Horizon.fixture("operation")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/operations/124624072438579201/effects" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("effects")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/operations/error", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(
        :get,
        @base_url <> "/operations?cursor=12884905985" <> _query,
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
        @base_url <> "/operations?cursor=12884905987" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/operations" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("operations")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/payments" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("payments")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.OperationsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedOperationRequests

  alias Stellar.Horizon.{
    Collection,
    Effect,
    Error,
    Operation,
    Operations
  }

  alias Stellar.Horizon.Operation.{CreateAccount, Payment, SetOptions, PathPaymentStrictSend}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedOperationRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{operation_id: 124_624_072_438_579_201}
  end

  test "retrieve/1", %{operation_id: operation_id} do
    {:ok,
     %Operation{
       body: %PathPaymentStrictSend{
         amount: 26.5544244,
         asset_code: "BRL",
         asset_issuer: "GDVKY2GU2DRXWTBEYJJWSFXIGBZV6AZNBVVSUHEPZI54LIS6BA7DVVSP",
         asset_type: "credit_alphanum4",
         destination_min: 26.5544244,
         from: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z",
         source_amount: 5.0,
         source_asset_code: "USD",
         source_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
         source_asset_type: "credit_alphanum4",
         to: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z"
       },
       created_at: ~U[2020-04-04 13:47:50Z],
       id: 124_624_072_438_579_201,
       source_account: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z",
       transaction_hash: "2b863994825fe85b80bfdff433b348d5ce80b23cd9ee2a56dcd6ee1abd52c9f8",
       transaction_successful: true,
       type: "path_payment_strict_send",
       type_i: 13
     }} = Operations.retrieve(operation_id)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Operation{
           body: %SetOptions{
             master_key_weight: 0
           },
           created_at: ~U[2015-09-30 17:15:54Z],
           id: 12_884_905_987,
           paging_token: "12884905987",
           source_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
           transaction: nil,
           transaction_hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
           transaction_successful: true,
           type: "set_options",
           type_i: 5
         },
         %Operation{
           body: %Payment{
             amount: 99_999_999_959.99997,
             asset_code: nil,
             asset_issuer: nil,
             asset_type: "native",
             from: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
             to: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB"
           },
           created_at: ~U[2015-09-30 17:15:54Z],
           id: 12_884_905_986,
           paging_token: "12884905986",
           source_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
           transaction: nil,
           transaction_hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
           transaction_successful: true,
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %CreateAccount{
             account: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB",
             funder: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
             starting_balance: 20.0
           },
           created_at: ~U[2015-09-30 17:15:54Z],
           id: 12_884_905_985,
           paging_token: "12884905985",
           source_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
           transaction: nil,
           transaction_hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
           transaction_successful: true,
           type: "create_account",
           type_i: 0
         }
       ]
     }} = Operations.all()
  end

  test "list_effects/2", %{operation_id: operation_id} do
    {:ok,
     %Collection{
       records: [
         %Effect{type: "account_created", created_at: ~U[2015-09-30 17:15:54Z]},
         %Effect{type: "account_debited", created_at: ~U[2015-09-30 17:16:54Z]},
         %Effect{type: "signer_created", created_at: ~U[2015-09-30 17:17:54Z]}
       ]
     }} = Operations.list_effects(operation_id, limit: 3)
  end

  test "list_payments/1" do
    {:ok,
     %Collection{
       records: [
         %Operation{
           id: 165_248_737_866_100_737,
           body: %Payment{amount: 0.0000001},
           type: "payment"
         },
         %Operation{
           id: 164_316_377_777_254_401,
           body: %Payment{amount: 1.0},
           type: "payment",
           type_i: 1
         },
         %Operation{
           id: 163_385_576_757_178_369,
           body: %Payment{amount: 1.0},
           type: "payment",
           type_i: 1
         }
       ]
     }} = Operations.list_payments(limit: 3)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Operations.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Operations.all(limit: 3)
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
     }} = Operations.retrieve("error")
  end
end
