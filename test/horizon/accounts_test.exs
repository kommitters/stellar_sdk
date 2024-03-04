defmodule Stellar.Horizon.Client.CannedAccountRequests do
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
  def request(:get, @base_url <> "/accounts/not_found", _headers, _body, _opts) do
    json_error = Horizon.fixture("404")
    {:ok, 404, [], json_error}
  end

  def request(
        :get,
        @base_url <>
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/effects" <> _query,
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
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/offers" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("offers")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/trades" <> _query,
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
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/transactions" <>
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
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/operations" <>
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
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/payments" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("payments")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/data" <> _query,
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("data")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <> "/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
        _headers,
        _body,
        _opts
      ) do
    json_body = Horizon.fixture("account")
    {:ok, 200, [], json_body}
  end

  def request(
        :get,
        @base_url <>
          "/accounts?cursor=GDRREYWHQWJDICNH4SAH4TT2JRBYRPTDYIMLK4UWBDT3X3ZVVYT6I4UQ&limit=3&order=asc" <>
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
          "/accounts?cursor=GDRREYWHQWJDICNH4SAH4TT2JRBYRPTDYIMLK4UWBDT3X3ZVVYT6I4UQ&limit=3&order=desc" <>
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

  def request(:get, @base_url <> "/accounts" <> _query, _headers, _body, _opts) do
    json_body = Horizon.fixture("accounts")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.AccountsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedAccountRequests

  alias Stellar.Horizon.{
    Account,
    Accounts,
    Collection,
    Effect,
    Error,
    Offer,
    Operation,
    Trade,
    Transaction,
    Server
  }

  alias Stellar.Horizon.Operation.{CreateAccount, Payment, SetOptions}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedAccountRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{account_id: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}
  end

  test "retrieve/1", %{account_id: account_id} do
    {:ok,
     %Account{
       account_id: ^account_id,
       balances: [
         %Account.Balance{
           asset_code: "EURT",
           asset_issuer: "GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S",
           asset_type: "credit_alphanum4"
         },
         %Account.Balance{
           asset_code: nil,
           asset_issuer: nil,
           asset_type: "native",
           balance: "100.9998300"
         }
       ],
       data: %{NFT: "QkdFR0ZFVEVHRUhIRUVI"},
       flags: %Account.Flags{
         auth_clawback_enabled: false,
         auth_immutable: false,
         auth_required: false,
         auth_revocable: false
       },
       id: ^account_id,
       last_modified_time: ~U[2022-01-20 21:21:44Z],
       paging_token: ^account_id,
       sequence: 17_218_523_889_680,
       sequence_ledger: 581_889,
       sequence_time: 1_658_962_934,
       signers: [
         _signer1,
         _signer2,
         %Account.Signer{
           key: ^account_id,
           type: "ed25519_public_key",
           weight: 1
         }
       ],
       thresholds: %Account.Thresholds{
         high_threshold: 3,
         low_threshold: 1,
         med_threshold: 2
       }
     }} = Accounts.retrieve(Server.testnet(), account_id)
  end

  test "fetch_next_sequence_number/1", %{account_id: account_id} do
    {:ok, 17_218_523_889_681} = Accounts.fetch_next_sequence_number(Server.testnet(), account_id)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Account{id: "GD42RQNXTRIW6YR3E2HXV5T2AI27LBRHOERV2JIYNFMXOBA234SWLQQB"},
         %Account{id: "GAP2KHWUMOHY7IO37UJY7SEBIITJIDZS5DRIIQRPEUT4VUKHZQGIRWS4"},
         %Account{id: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB"}
       ]
     }} = Accounts.all(Server.testnet())
  end

  test "list_effects/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Effect{type: "account_created", created_at: ~U[2015-09-30 17:15:54Z]},
         %Effect{type: "account_debited", created_at: ~U[2015-09-30 17:16:54Z]},
         %Effect{type: "signer_created", created_at: ~U[2015-09-30 17:17:54Z]},
         %Effect{type: "contract_debited", created_at: ~U[2023-10-10 15:53:13Z]},
         %Effect{type: "contract_credited", created_at: ~U[2023-10-10 15:52:40Z]}
       ]
     }} = Accounts.list_effects(Server.testnet(), account_id, limit: 5)
  end

  test "list_offers/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Offer{
           seller: ^account_id,
           buying: %{
             asset_type: "credit_alphanum4",
             asset_code: "BTCN",
             asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
           },
           amount: "214.9999939"
         },
         %Offer{
           seller: ^account_id,
           selling: %{
             asset_type: "credit_alphanum4",
             asset_code: "BTCN",
             asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
           },
           amount: "24.9999990"
         }
       ]
     }} = Accounts.list_offers(Server.testnet(), account_id)
  end

  test "list_trades/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Trade{
           base_offer_id: 165_561_423,
           counter_account: ^account_id,
           base_amount: "4433.2000000"
         },
         %Trade{
           base_offer_id: 165_561_423,
           counter_account: ^account_id,
           base_amount: "10.0000000"
         },
         %Trade{
           base_offer_id: 165_561_423,
           counter_account: ^account_id,
           base_amount: "748.5338945"
         }
       ]
     }} = Accounts.list_trades(Server.testnet(), account_id)
  end

  test "list_transactions/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Transaction{
           id: "3389e9f0f1a65f19736cacf544c2e825313e8447f569233bb8db39aa607c8889",
           source_account: ^account_id,
           ledger: 7840
         },
         %Transaction{
           id: "2db4b22ca018119c5027a80578813ffcf582cda4aa9e31cd92b43cf1bda4fc5a",
           source_account: ^account_id,
           ledger: 7841
         },
         %Transaction{
           id: "3ce2aca2fed36da2faea31352c76c5e412348887a4c119b1e90de8d1b937396a",
           source_account: ^account_id,
           ledger: 7855
         }
       ]
     }} = Accounts.list_transactions(Server.testnet(), account_id, limit: 3, order: :asc)
  end

  test "list_operations/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Operation{
           body: %SetOptions{},
           source_account: ^account_id,
           type: "set_options",
           type_i: 5
         },
         %Operation{
           body: %Payment{},
           source_account: ^account_id,
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %CreateAccount{},
           source_account: ^account_id,
           type: "create_account",
           type_i: 0
         }
       ]
     }} = Accounts.list_operations(Server.testnet(), account_id, limit: 3, order: :desc)
  end

  test "list_payments/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Operation{
           source_account: ^account_id,
           body: %Payment{from: ^account_id, amount: "0.0000001"},
           type: "payment"
         },
         %Operation{
           body: %Payment{to: ^account_id, amount: "1.0000000"},
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %Payment{to: ^account_id, amount: "1.0000000"},
           type: "payment",
           type_i: 1
         }
       ]
     }} = Accounts.list_payments(Server.testnet(), account_id, limit: 3)
  end

  test "data/1", %{account_id: account_id} do
    {:ok, %Account.Data{value: "QkdFR0ZFVEVHRUhIRUVI"}} =
      Accounts.data(Server.testnet(), account_id, "NFT")
  end

  test "paginate_collection prev" do
    {:ok, %Collection{prev: paginate_prev_fn}} = Accounts.all(Server.testnet(), limit: 3)
    paginate_prev_fn.()

    assert_receive({:paginated, :prev})
  end

  test "paginate_collection next" do
    {:ok, %Collection{next: paginate_next_fn}} = Accounts.all(Server.testnet(), limit: 3)
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
     }} = Accounts.retrieve(Server.testnet(), "not_found")
  end

  test "fetch_next_sequence_number error" do
    {:error,
     %Error{
       extras: nil,
       status_code: 404,
       title: "Resource Missing",
       type: "https://stellar.org/horizon-errors/not_found"
     }} = Accounts.fetch_next_sequence_number(Server.testnet(), "not_found")
  end
end
