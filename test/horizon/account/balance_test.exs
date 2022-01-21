defmodule Stellar.Horizon.Account.BalanceTest do
  use ExUnit.Case

  alias Stellar.Horizon.Account.Balance

  setup do
    %{
      attrs: %{
        balance: "100.1",
        asset_type: "native",
        buying_liabilities: "10.2",
        selling_liabilities: "5.0",
        limit: 0,
        last_modified_ledger: 39_154_245,
        is_authorized: false,
        is_authorized_to_maintain_liabilities: true,
        asset_code: "native",
        asset_issuer: nil
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %Balance{
      balance: 100.1,
      asset_type: "native",
      buying_liabilities: 10.2,
      selling_liabilities: 5.0,
      limit: 0,
      last_modified_ledger: 39_154_245,
      is_authorized: false,
      is_authorized_to_maintain_liabilities: true,
      asset_code: "native",
      asset_issuer: nil
    } = Balance.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Balance{
      balance: nil,
      asset_type: nil,
      buying_liabilities: nil,
      selling_liabilities: nil,
      limit: nil,
      last_modified_ledger: nil,
      is_authorized: nil,
      is_authorized_to_maintain_liabilities: nil,
      asset_code: nil,
      asset_issuer: nil
    } = Balance.new(%{})
  end
end
