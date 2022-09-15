defmodule Stellar.Horizon.LedgerTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Ledger

  setup do
    json_body = Horizon.fixture("ledger")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Ledger{
      id: "31c33314a9d6f1d1e07040029f56403fc410829a45dfe9cc662c6b2dce8f53b3",
      paging_token: "42949672960",
      hash: "31c33314a9d6f1d1e07040029f56403fc410829a45dfe9cc662c6b2dce8f53b3",
      prev_hash: "da0516f96a9d3a00e8f60c60307cad062021cbad3c99f72ad8e277803dece482",
      sequence: 10,
      successful_transaction_count: 0,
      failed_transaction_count: 0,
      operation_count: 0,
      tx_set_operation_count: 0,
      closed_at: ~U[2015-09-30 17:16:29Z],
      total_coins: "100000000000.0000000",
      fee_pool: "0.0000300",
      base_fee_in_stroops: 100,
      base_reserve_in_stroops: 100_000_000,
      max_tx_set_size: 500,
      protocol_version: 1,
      header_xdr: "AAAAAdofgbAA==="
    } = Ledger.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Ledger{
      id: nil,
      paging_token: nil,
      hash: nil,
      prev_hash: nil,
      sequence: nil,
      successful_transaction_count: nil,
      failed_transaction_count: nil,
      operation_count: nil,
      tx_set_operation_count: nil,
      closed_at: nil,
      total_coins: nil,
      fee_pool: nil,
      base_fee_in_stroops: nil,
      base_reserve_in_stroops: nil,
      max_tx_set_size: nil,
      protocol_version: nil,
      header_xdr: nil
    } = Ledger.new(%{})
  end
end
