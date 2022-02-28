defmodule Stellar.Horizon.TradeTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Trade

  setup do
    json_body = Horizon.fixture("trade")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Trade{
      id: "3697472920621057-2",
      ledger_close_time: ~U[2015-11-18 03:47:47Z],
      trade_type: "orderbook",
      base_offer_id: "8",
      base_account: "GAVH5JM5OKXGMQDS7YPRJ4MQCPXJUGH26LYQPQJ4SOMOJ4SXY472ZM7G",
      base_amount: 20.0000000,
      base_asset_type: "native",
      counter_offer_id: "10",
      counter_account: "GBB4JST32UWKOLGYYSCEYBHBCOFL2TGBHDVOMZP462ET4ZRD4ULA7S2L",
      counter_amount: 5.3600000,
      counter_asset_type: "credit_alphanum4",
      counter_asset_code: "JPY",
      counter_asset_issuer: "GBVAOIACNSB7OVUXJYC5UE2D4YK2F7A24T7EE5YOMN4CE6GCHUTOUQXM",
      base_is_seller: true,
      price: %{
        n: "67",
        d: "250"
      }
    } = Trade.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Trade{
      id: nil,
      ledger_close_time: nil,
      base_offer_id: nil,
      base_account: nil,
      base_amount: nil,
      base_asset_type: nil,
      counter_offer_id: nil,
      counter_account: nil,
      counter_amount: nil,
      counter_asset_type: nil,
      counter_asset_code: nil,
      counter_asset_issuer: nil,
      base_is_seller: nil,
      price: nil
    } = Trade.new(%{})
  end
end
