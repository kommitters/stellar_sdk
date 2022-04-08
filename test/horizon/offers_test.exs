defmodule Stellar.Horizon.Client.CannedOfferRequests do
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
  def request(:get, @base_url <> "/offers/165561423", _headers, _body, _opts) do
    json_body = Horizon.fixture("offer")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/offers/not_found", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(:get, @base_url <> "/offers/165561423/trades" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("trades")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/offers?cursor=164943216" <> _query, _headers, _body, _opts) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :next})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/offers?cursor=164555927" <> _query, _headers, _body, _opts) do
    json_body =
      ~s<{"_embedded": {"records": []}, "_links": {"prev": {"href": ""}, "next": {"href": ""}}}>

    send(self(), {:paginated, :prev})
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/offers" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("offers")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.OffersTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedOfferRequests
  alias Stellar.Horizon.{Collection, Error, Offer, Offers, Trade}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedOfferRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{offer_id: 165_561_423}
  end

  test "retrieve/1", %{offer_id: offer_id} do
    {:ok,
     %Offer{
       amount: 18_421.4486092,
       buying: %{asset_type: "native"},
       id: 165_561_423,
       last_modified_ledger: 28_411_995,
       last_modified_time: ~U[2020-02-26 19:29:16Z],
       paging_token: "165561423",
       price: 0.0479171,
       price_r: %{d: 941_460_545, n: 45_112_058},
       seller: "GCK4WSNF3F6ZNCMK6BU77ZCZ3NMF3JGU2U3ZAPKXYBKYYCJA72FDBY7K",
       selling: %{
         asset_code: "NGNT",
         asset_issuer: "GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD",
         asset_type: "credit_alphanum4"
       },
       sponsor: nil
     }} = Offers.retrieve(offer_id)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Offer{
           id: 164_555_927,
           buying: %{
             asset_type: "credit_alphanum4",
             asset_code: "BTCN",
             asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
           },
           price: 0.1162791
         },
         %Offer{
           id: 164_943_216,
           selling: %{
             asset_type: "credit_alphanum4",
             asset_code: "BTCN",
             asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
           },
           price: 12.8899964
         }
       ]
     }} = Offers.all()
  end

  test "list_trades/2", %{offer_id: offer_id} do
    {:ok,
     %Collection{
       records: [
         %Trade{base_offer_id: ^offer_id, base_amount: 4433.20},
         %Trade{base_offer_id: ^offer_id, base_amount: 10.0},
         %Trade{base_offer_id: ^offer_id, base_amount: 748.5338945}
       ]
     }} = Offers.list_trades(offer_id)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Offers.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Offers.all(limit: 3)
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
     }} = Offers.retrieve("not_found")
  end
end
