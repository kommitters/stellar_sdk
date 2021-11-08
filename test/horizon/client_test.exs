defmodule Stellar.Horizon.Client.CannedClientImpl do
  @moduledoc false

  import Stellar.Test.Fixtures, only: [account_data: 1]

  @behaviour Stellar.Horizon.Client.Spec

  @impl true
  def request(:get, "/accounts/123", _headers, _body, _opts) do
    {:ok, %{status_code: 404, body: ~s<{"status": 404, "title": "Resource Missing"}>}}
  end

  def request(:get, "/accounts/" <> id, _headers, _body, _opts) do
    {:ok, %{status_code: 200, body: account_data(id)}}
  end

  def request(:delete, _path, _headers, _body, _opts) do
    {:error, %{reason: "error"}}
  end
end

defmodule Stellar.Horizon.ClientTest do
  use ExUnit.Case

  import Stellar.Test.Fixtures, only: [account_data: 1]

  alias Stellar.Horizon.Client

  setup do
    %{
      body: account_data("GAYOLLLUIZE4DZMBB2ZBKGBUBZLIOYU6XBNXCW4BVA"),
      body_404: ~s<{"status": 404, "title": "Resource Missing"}>
    }
  end

  test "request/5 success", %{body: body} do
    {:ok, %{status_code: 200, body: ^body}} =
      Client.request(:get, "/accounts/GAYOLLLUIZE4DZMBB2ZBKGBUBZLIOYU6XBNXCW4BVA")
  end

  test "request/5 not_found", %{body_404: body} do
    {:ok, %{status_code: 404, body: ^body}} = Client.request(:get, "/accounts/123")
  end

  test "request/5 error" do
    {:error, %{reason: "error"}} = Client.request(:delete, "/accounts")
  end
end
