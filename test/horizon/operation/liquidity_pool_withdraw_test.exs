defmodule Stellar.Horizon.Operation.LiquidityPoolWithdrawTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.LiquidityPoolWithdraw

  setup do
    %{
      attrs: %{
        liquidity_pool_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        reserves_received: [
          %{
            asset: "JPY:GBVAOIACNSB7OVUXJYC5UE2D4YK2F7A24T7EE5YOMN4CE6GCHUTOUQXM",
            amount: "1000.0000005"
          },
          %{
            asset: "EURT:GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S",
            amount: "3000.0000005"
          }
        ],
        reserves_min: [
          %{
            asset: "JPY:GBVAOIACNSB7OVUXJYC5UE2D4YK2F7A24T7EE5YOMN4CE6GCHUTOUQXM",
            amount: "983.0000005"
          },
          %{
            asset: "EURT:GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S",
            amount: "2378.0000005"
          }
        ],
        shares: "1000"
      }
    }
  end

  test "new/2", %{attrs: %{liquidity_pool_id: liquidity_pool_id} = attrs} do
    %LiquidityPoolWithdraw{
      liquidity_pool_id: ^liquidity_pool_id,
      reserves_received: [%{amount: 1000.0000005}, %{amount: 3000.0000005}],
      reserves_min: [%{amount: 983.0000005}, %{amount: 2378.0000005}],
      shares: 1000
    } = LiquidityPoolWithdraw.new(attrs)
  end

  test "new/2 empty_attrs" do
    %LiquidityPoolWithdraw{
      liquidity_pool_id: nil,
      reserves_received: nil,
      reserves_min: nil,
      shares: nil
    } = LiquidityPoolWithdraw.new(%{})
  end
end
