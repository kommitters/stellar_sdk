defmodule Stellar.Horizon.Client.CannedClientImpl do
  @moduledoc false

  @behaviour Stellar.Horizon.Client.Spec

  @impl true
  def request(_method, _path, _headers, _body, _opts) do
    send(self(), {:requested, 200})
    {:ok, 200, [], nil}
  end
end

defmodule Stellar.Horizon.ClientTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client

  test "request/5" do
    Client.request(:get, "/accounts/GAYOLLLUIZE4DZMBB2ZBKGBUBZLIOYU6XBNXCW4BVA")
    assert_receive({:requested, 200})
  end
end
