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
      asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
      claimable_balances_amount: "36303.8674450",
      amount: "1347404.4083346",
      num_accounts: 9390,
      accounts: %{
        authorized: 9390,
        authorized_to_maintain_liabilities: 1240,
        unauthorized: 5
      },
      balances: %{
        authorized: "1347404.4083346",
        authorized_to_maintain_liabilities: "177931.9984610",
        unauthorized: "717.4677360"
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
      balances: nil
    } = Asset.new(%{})
  end
end
