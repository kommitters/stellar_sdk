defmodule Stellar.Horizon.Transaction.PreconditionsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Transaction.{Preconditions, LedgerBounds, TimeBounds}

  setup do
    %{
      attrs: %{
        time_bounds: %{
          min_time: "0",
          max_time: "1659019454"
        },
        ledger_bounds: %{
          min_ledger: 101_232,
          max_ledger: 3_123_123_213_123
        },
        min_account_sequence: "12345",
        min_account_sequence_age: 4_567,
        min_account_sequence_ledger_gap: 78_910,
        extra_signers: [
          "GC7HDCY5A5Q6BJ466ABYJSZWPKQIWBPRHZMT3SUHW2YYDXGPZVS7I36S",
          "GCO2IP3MJNUOKS4PUDI4C7LGGMQDJGXG3COYX3WSB4HHNAHKYV5YL3VC"
        ]
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %Preconditions{
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
    } = Preconditions.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Preconditions{
      time_bounds: nil,
      ledger_bounds: nil,
      min_account_sequence: nil,
      min_account_sequence_age: nil,
      min_account_sequence_ledger_gap: nil,
      extra_signers: nil
    } = Preconditions.new(%{})
  end
end
