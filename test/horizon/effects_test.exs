defmodule Stellar.Horizon.Client.CannedEffectRequests do
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
  def request(:get, @base_url <> "/effects?cursor=error", _headers, _body, _opts) do
    json_error = Horizon.fixture("400")
    {:ok, 400, [], json_error}
  end

  def request(
        :get,
        @base_url <> "/effects?cursor=12884905985-3" <> _query,
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
        @base_url <> "/effects?cursor=12884905985-1" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/effects" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("effects")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.EffectsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedEffectRequests
  alias Stellar.Horizon.{Collection, Error, Effect, Effects}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedEffectRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Effect{
           account: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB",
           attributes: %{amount: nil, starting_balance: 20.0},
           created_at: ~U[2015-09-30 17:15:54Z],
           id: "0000000012884905985-0000000001",
           paging_token: "12884905985-1",
           type: "account_created",
           type_i: 0
         },
         %Effect{
           account: "GAAZI4TCR3TY5OJHCTJC2A4QSY6CJWJH5IAJTGKIN2ER7LBNVKOCCWN7",
           attributes: %{amount: 20.0, asset_type: "native", starting_balance: nil},
           created_at: ~U[2015-09-30 17:16:54Z],
           id: "0000000012884905985-0000000002",
           paging_token: "12884905985-2",
           type: "account_debited",
           type_i: 3
         },
         %Effect{
           account: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB",
           attributes: %{
             amount: nil,
             key: "",
             public_key: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB",
             starting_balance: nil,
             weight: 1
           },
           created_at: ~U[2015-09-30 17:17:54Z],
           id: "0000000012884905985-0000000003",
           paging_token: "12884905985-3",
           type: "signer_created",
           type_i: 10
         }
       ]
     }} = Effects.all(limit: 3)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Effects.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Effects.all(limit: 3)
    paginate_next_fn.()

    assert_receive({:paginated, :next})
  end

  test "error" do
    {:error,
     %Error{
       detail: "The request you sent was invalid in some way.",
       extras: %{invalid_field: "cursor", reason: "cursor: invalid value"},
       status_code: 400,
       title: "Bad Request",
       type: "https://stellar.org/horizon-errors/bad_request"
     }} = Effects.all(cursor: "error")
  end
end
