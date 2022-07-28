defmodule Stellar.Horizon.TransactionTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon

  alias Stellar.Horizon.{
    Transaction,
    Transaction.Preconditions,
    Transaction.TimeBounds,
    Transaction.LedgerBounds
  }

  setup do
    json_body = Horizon.fixture("transaction")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Transaction{
      id: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
      successful: true,
      fee_charged: 100,
      max_fee: 100,
      operation_count: 1,
      hash: "132c440e984ab97d895f3477015080aafd6c4375f6a70a87327f7f95e13c4e31",
      source_account: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
      source_account_sequence: 64_034_663_849_209_932,
      created_at: ~U[2020-01-27 22:13:17Z],
      result_xdr: "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAA=",
      memo_type: "text",
      memo: "298424",
      valid_after: ~U[1970-01-01 00:00:00Z],
      valid_before: ~U[2020-01-27 22:13:26Z],
      preconditions: %Preconditions{
        time_bounds: %TimeBounds{
          min_time: 0,
          max_time: 1_659_019_454
        },
        ledger_bounds: %LedgerBounds{
          min_ledger: 101_232,
          max_ledger: 3_123_123_213_123
        },
        min_account_sequence: 12_345,
        min_account_sequence_age: 4_567,
        min_account_sequence_ledger_gap: 78_910,
        extra_signers: [
          "GC7HDCY5A5Q6BJ466ABYJSZWPKQIWBPRHZMT3SUHW2YYDXGPZVS7I36S",
          "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
        ]
      }
    } = Transaction.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Transaction{
      id: nil,
      successful: nil,
      fee_charged: nil,
      max_fee: nil,
      operation_count: nil,
      hash: nil,
      source_account: nil,
      source_account_sequence: nil,
      created_at: nil,
      result_xdr: nil,
      memo_type: nil,
      memo: nil,
      valid_after: nil,
      valid_before: nil,
      preconditions: nil
    } = Transaction.new(%{})
  end
end
