defmodule Stellar.Horizon.Client.CannedAccountRequests do
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
    Transaction
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
           balance: 100.99983
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
     }} = Accounts.retrieve(account_id)
  end

  test "fetch_next_sequence_number/1", %{account_id: account_id} do
    {:ok, 17_218_523_889_681} = Accounts.fetch_next_sequence_number(account_id)
  end

  test "all/1" do
    {:ok,
     %Collection{
       records: [
         %Account{id: "GD42RQNXTRIW6YR3E2HXV5T2AI27LBRHOERV2JIYNFMXOBA234SWLQQB"},
         %Account{id: "GAP2KHWUMOHY7IO37UJY7SEBIITJIDZS5DRIIQRPEUT4VUKHZQGIRWS4"},
         %Account{id: "GALPCCZN4YXA3YMJHKL6CVIECKPLJJCTVMSNYWBTKJW4K5HQLYLDMZTB"}
       ]
     }} = Accounts.all()
  end

  test "list_effects/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       next:
         "https://horizon.stellar.org/effects?cursor=12884905985-3\u0026limit=3\u0026order=asc",
       prev:
         "https://horizon.stellar.org/effects?cursor=12884905985-1\u0026limit=3\u0026order=desc",
       records: [
         %Effect{type: "account_created", created_at: ~U[2015-09-30 17:15:54Z]},
         %Effect{type: "account_debited", created_at: ~U[2015-09-30 17:16:54Z]},
         %Effect{type: "signer_created", created_at: ~U[2015-09-30 17:17:54Z]}
       ]
     }} = Accounts.list_effects(account_id, limit: 3)
  end

  test "list_offers/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       next:
         "https://horizon.stellar.org/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/offers?cursor=164943216\u0026limit=10\u0026order=asc",
       prev:
         "https://horizon.stellar.org/accounts/GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD/offers?cursor=164555927\u0026limit=10\u0026order=desc",
       records: [
         %Offer{
           seller: ^account_id,
           buying: %{
             asset_type: "credit_alphanum4",
             asset_code: "BTCN",
             asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
           },
           amount: 214.9999939
         },
         %Offer{
           seller: ^account_id,
           selling: %{
             asset_type: "credit_alphanum4",
             asset_code: "BTCN",
             asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN"
           },
           amount: 24.9999990
         }
       ]
     }} = Accounts.list_offers(account_id)
  end

  test "list_trades/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Trade{
           base_offer_id: "104078276",
           counter_account: ^account_id,
           base_amount: 4433.20
         },
         %Trade{
           base_offer_id: "104273938",
           counter_account: ^account_id,
           base_amount: 10.0
         },
         %Trade{
           base_offer_id: "104299223",
           counter_account: ^account_id,
           base_amount: 748.5338945
         }
       ]
     }} = Accounts.list_trades(account_id)
  end

  test "list_transactions/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       next:
         "https://horizon.stellar.org/transactions?cursor=33736968114176\u0026limit=3\u0026order=asc",
       prev:
         "https://horizon.stellar.org/transactions?cursor=12884905984\u0026limit=3\u0026order=desc",
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
     }} = Accounts.list_transactions(account_id, limit: 3, order: :asc)
  end

  test "list_operations/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       next:
         "https://horizon.stellar.org/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/operations?cursor=12884905985&limit=3&order=desc",
       prev:
         "https://horizon.stellar.org/transactions/132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31/operations?cursor=12884905987&limit=3&order=asc",
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
     }} = Accounts.list_operations(account_id, limit: 3, order: :desc)
  end

  test "list_payments/1", %{account_id: account_id} do
    {:ok,
     %Collection{
       records: [
         %Operation{
           source_account: ^account_id,
           body: %Payment{from: ^account_id, amount: 0.0000001},
           type: "payment"
         },
         %Operation{
           body: %Payment{to: ^account_id, amount: 1.0},
           type: "payment",
           type_i: 1
         },
         %Operation{
           body: %Payment{to: ^account_id, amount: 1.0},
           type: "payment",
           type_i: 1
         }
       ]
     }} = Accounts.list_payments(account_id, limit: 3)
  end

  test "data/1", %{account_id: account_id} do
    {:ok, %Account.Data{value: "QkdFR0ZFVEVHRUhIRUVI"}} = Accounts.data(account_id, "NFT")
  end

  test "error" do
    {:error,
     %Error{
       extras: nil,
       status_code: 404,
       title: "Resource Missing",
       type: "https://stellar.org/horizon-errors/not_found"
     }} = Accounts.retrieve("not_found")
  end

  test "fetch_next_sequence_number error" do
    {:error,
     %Error{
       extras: nil,
       status_code: 404,
       title: "Resource Missing",
       type: "https://stellar.org/horizon-errors/not_found"
     }} = Accounts.fetch_next_sequence_number("not_found")
  end
end
