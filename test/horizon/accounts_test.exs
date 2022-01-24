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

  def request(:get, @base_url <> "/accounts/" <> _account_id, _headers, _body, _opts) do
    json_body = Horizon.fixture("account")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.AccountsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedAccountRequests
  alias Stellar.Horizon.{Account, Accounts, Error}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedAccountRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)

    %{account_id: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}
  end

  describe "retrieve/1" do
    test "success", %{account_id: account_id} do
      {:ok, %Account{id: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}} =
        Accounts.retrieve(account_id)
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
  end

  describe "fetch_next_sequence_number/1" do
    test "success", %{account_id: account_id} do
      {:ok, 17_218_523_889_681} = Accounts.fetch_next_sequence_number(account_id)
    end

    test "error" do
      {:error,
       %Error{
         extras: nil,
         status_code: 404,
         title: "Resource Missing",
         type: "https://stellar.org/horizon-errors/not_found"
       }} = Accounts.fetch_next_sequence_number("not_found")
    end
  end
end
