defmodule Stellar.Horizon.Client.CannedFeeStatRequests do
  alias Stellar.Test.Fixtures.Horizon

  @base_url "https://horizon-testnet.stellar.org"

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          options :: list()
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, atom()}

  def request(:get, @base_url <> "/fee_stats", _headers, _body, _opts) do
    json_body = Horizon.fixture("fee_stats")
    {:ok, 200, [], json_body}
  end
end

defmodule Stellar.Horizon.FeeStatsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Client.CannedFeeStatRequests
  alias Stellar.Horizon.{FeeStat, FeeStats, Server}

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedFeeStatRequests)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
    end)
  end

  test "retrieve/0" do
    {:ok,
     %FeeStat{
       fee_charged: %{
         max: "100",
         min: "100",
         mode: "100",
         p10: "100",
         p20: "100",
         p30: "100",
         p40: "100",
         p50: "100",
         p60: "100",
         p70: "100",
         p80: "100",
         p90: "100",
         p95: "100",
         p99: "100"
       },
       last_ledger: 155_545,
       last_ledger_base_fee: 100,
       ledger_capacity_usage: "0.01",
       max_fee: %{
         max: "100",
         min: "100",
         mode: "100",
         p10: "100",
         p20: "100",
         p30: "100",
         p40: "100",
         p50: "100",
         p60: "100",
         p70: "100",
         p80: "100",
         p90: "100",
         p95: "100",
         p99: "100"
       }
     }} = FeeStats.retrieve(Server.testnet())
  end
end
