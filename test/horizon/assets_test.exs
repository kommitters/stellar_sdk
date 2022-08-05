defmodule Stellar.Horizon.Client.CannedAssetRequests do
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
  def request(:get, @base_url <> "/assets?asset_code=" <> _asset_code, _headers, _body, _opts) do
    json_body = Horizon.fixture("assets")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/assets?asset_issuer=" <> _asset_issuer, _headers, _body, _opts) do
    json_body = Horizon.fixture("assets")
    {:ok, 200, [], json_body}
  end

  def request(:get, @base_url <> "/assets?cursor=error", _headers, _body, _opts) do
    json_error = Horizon.fixture("400")
    {:ok, 400, [], json_error}
  end

  def request(
        :get,
        @base_url <>
          "/assets?cursor=MTK_GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD_credit_alphanum4" <>
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
          "/assets?cursor=BTCNEW2022_GCEU4UKMCN6XDTXOKVR35HEMSNT5HRT36ZM6QCZPFEVSSP6M2NCYZOJW_credit_alphanum12" <>
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

  def request(:get, @base_url <> "/assets" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("assets")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.AssetsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedAssetRequests
  alias Stellar.Horizon.{Asset, Assets, Collection, Error}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedAssetRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{
      asset_code: "BTCN",
      asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
    }
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Asset{
           asset_type: "credit_alphanum12",
           asset_code: "BTCNEW2022",
           asset_issuer: "GCEU4UKMCN6XDTXOKVR35HEMSNT5HRT36ZM6QCZPFEVSSP6M2NCYZOJW"
         },
         %Asset{
           asset_type: "credit_alphanum4",
           asset_code: "BTCN",
           asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
         },
         %Asset{
           asset_type: "credit_alphanum4",
           asset_code: "MTK",
           asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
         }
       ]
     }} = Assets.all(limit: 3)
  end

  test "list_by_asset_code/2", %{asset_code: asset_code} do
    {:ok,
     %Collection{
       records: [
         _asset,
         %Asset{
           asset_code: "BTCN",
           asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
         },
         _asset2
       ]
     }} = Assets.list_by_asset_code(asset_code, limit: 3)
  end

  test "list_by_asset_issuer/2", %{asset_issuer: asset_issuer} do
    {:ok,
     %Collection{
       records: [
         _asset,
         %Asset{
           asset_code: "BTCN",
           asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
         },
         %Asset{
           asset_code: "MTK",
           asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
         }
       ]
     }} = Assets.list_by_asset_issuer(asset_issuer, limit: 3)
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Assets.all(limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Assets.all(limit: 3)
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
     }} = Assets.all(cursor: "error")
  end
end
