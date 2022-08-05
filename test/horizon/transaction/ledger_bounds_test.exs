defmodule Stellar.Horizon.Transaction.LedgerBoundsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Transaction.LedgerBounds

  setup do
    %{
      attrs: %{
        min_ledger: 101_232,
        max_ledger: 3_123_123_213_123
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %LedgerBounds{
      min_ledger: 101_232,
      max_ledger: 3_123_123_213_123
    } = LedgerBounds.new(attrs)
  end

  test "new/2 empty_attrs" do
    %LedgerBounds{
      min_ledger: nil,
      max_ledger: nil
    } = LedgerBounds.new(%{})
  end
end
