defmodule Stellar.Horizon.LiquidityPoolTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.LiquidityPool

  setup do
    json_body = Horizon.fixture("liquidity_pool")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %LiquidityPool{
      id: "0052d44a6c260660115f07c5a78631770e62aae3ffde96731c44b1509e9c8434",
      fee_bp: 30,
      type: "constant_product",
      total_trustlines: 1,
      total_shares: "500000000.0000000",
      reserves: [
        %{
          asset: "XAU:GB3OE4IBQTYQFZZS5RXQHE4IPQL7ONOFOSAIS2NFRNMJKZEAI3AAUT2A",
          amount: "522256061.0743940"
        },
        %{
          asset: "ERRES:GA6ZAQGLDUEODDUUD3UD6PUFJYABWQA26SG5RK6E6CZ6OMD6AZKK5QNF",
          amount: "533666459.4045717"
        }
      ],
      last_modified_ledger: 39_767_560,
      last_modified_time: ~U[2022-02-24 11:48:09Z]
    } = LiquidityPool.new(attrs)
  end

  test "new/2 empty_attrs" do
    %LiquidityPool{
      id: nil,
      fee_bp: nil,
      type: nil,
      total_trustlines: nil,
      total_shares: nil,
      reserves: nil,
      last_modified_ledger: nil,
      last_modified_time: nil
    } = LiquidityPool.new(%{})
  end
end
