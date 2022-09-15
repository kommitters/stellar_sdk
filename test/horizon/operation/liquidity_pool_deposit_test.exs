defmodule Stellar.Horizon.Operation.LiquidityPoolDepositTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.LiquidityPoolDeposit

  setup do
    %{
      attrs: %{
        liquidity_pool_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        reserves_max: [
          %{
            asset: "JPY:GBVAOIACNSB7OVUXJYC5UE2D4YK2F7A24T7EE5YOMN4CE6GCHUTOUQXM",
            amount: "1000.0000005"
          },
          %{
            asset: "EURT:GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S",
            amount: "3000.0000005"
          }
        ],
        min_price: "0.2680000",
        min_price_r: %{n: 67, d: 250},
        max_price: "0.3680000",
        max_price_r: %{n: 73, d: 250},
        reserves_deposited: [
          %{
            asset: "JPY:GBVAOIACNSB7OVUXJYC5UE2D4YK2F7A24T7EE5YOMN4CE6GCHUTOUQXM",
            amount: "983.0000005"
          },
          %{
            asset: "EURT:GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S",
            amount: "2378.0000005"
          }
        ],
        shares_received: "1000"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        liquidity_pool_id: liquidity_pool_id,
        reserves_max: reserves_max,
        min_price: min_price,
        max_price: max_price,
        min_price_r: min_price_r,
        max_price_r: max_price_r,
        reserves_deposited: reserves_deposited
      } = attrs
  } do
    %LiquidityPoolDeposit{
      liquidity_pool_id: ^liquidity_pool_id,
      reserves_max: ^reserves_max,
      min_price: ^min_price,
      min_price_r: ^min_price_r,
      max_price: ^max_price,
      max_price_r: ^max_price_r,
      reserves_deposited: ^reserves_deposited,
      shares_received: 1000
    } = LiquidityPoolDeposit.new(attrs)
  end

  test "new/2 empty_attrs" do
    %LiquidityPoolDeposit{
      liquidity_pool_id: nil,
      reserves_max: nil,
      min_price: nil,
      min_price_r: nil,
      max_price: nil,
      max_price_r: nil,
      reserves_deposited: nil,
      shares_received: nil
    } = LiquidityPoolDeposit.new(%{})
  end
end
