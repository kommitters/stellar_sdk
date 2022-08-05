defmodule Stellar.TxBuild.LedgerBoundsTest do
  use ExUnit.Case

  alias StellarBase.XDR.{UInt32, OptionalLedgerBounds}
  alias StellarBase.XDR.LedgerBounds, as: LedgerBoundsXDR
  alias Stellar.TxBuild.LedgerBounds

  test "new/2" do
    %LedgerBounds{min_ledger: 0, max_ledger: 0} = LedgerBounds.new()
  end

  test "new/2 with_integer_values" do
    %LedgerBounds{min_ledger: 0, max_ledger: 123} =
      LedgerBounds.new(min_ledger: 0, max_ledger: 123)
  end

  test "new/2 with_invalid_values" do
    {:error, :invalid_ledger_bounds} = LedgerBounds.new(min_ledger: 0, max_ledger: "123")
  end

  test "to_xdr/1" do
    %OptionalLedgerBounds{ledger_bounds: nil} = LedgerBounds.new() |> LedgerBounds.to_xdr()
  end

  test "to_xdr/1 with_values" do
    min_ledger = UInt32.new(123)
    max_ledger = UInt32.new(456)
    ledger_bounds = LedgerBoundsXDR.new(min_ledger, max_ledger)

    %OptionalLedgerBounds{ledger_bounds: ^ledger_bounds} =
      LedgerBounds.new(min_ledger: 123, max_ledger: 456) |> LedgerBounds.to_xdr()
  end
end
