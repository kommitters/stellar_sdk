defmodule Stellar.Horizon.AssetTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Asset

  setup do
    json_body = Horizon.fixture("asset")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Asset{
      asset_type: "credit_alphanum4",
      asset_code: "USD",
      asset_issuer: "GA223QARVHSYZPRRXK3P2U4I33CEUCGBNDE4UHU2UZKFG63AJXBSPNKO",
      paging_token:
        "USD_GA223QARVHSYZPRRXK3P2U4I33CEUCGBNDE4UHU2UZKFG63AJXBSPNKO_credit_alphanum4",
      num_accounts: 4,
      num_claimable_balances: 0,
      num_liquidity_pools: 0,
      num_contracts: 0,
      amount: "100.0000000",
      accounts: %{
        authorized: 4,
        authorized_to_maintain_liabilities: 0,
        unauthorized: 0
      },
      claimable_balances_amount: "0.0000000",
      liquidity_pools_amount: "0.0000000",
      contracts_amount: "0.0000000",
      balances: %{
        authorized: "100.0000000",
        authorized_to_maintain_liabilities: "0.0000000",
        unauthorized: "0.0000000"
      },
      flags: %{
        auth_required: false,
        auth_revocable: false,
        auth_immutable: false,
        auth_clawback_enabled: false
      }
    } = Asset.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Asset{
      asset_type: nil,
      asset_code: nil,
      asset_issuer: nil,
      claimable_balances_amount: nil,
      amount: nil,
      num_accounts: nil,
      accounts: nil,
      balances: nil,
      num_liquidity_pools: nil,
      liquidity_pools_amount: nil
    } = Asset.new(%{})
  end
end
