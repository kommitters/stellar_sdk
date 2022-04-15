defmodule Stellar.TxBuild.LiquidityPoolDepositTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{Amount, LiquidityPoolDeposit, PoolID, Price}

  setup do
    liquidity_pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    max_amount_a = 20
    max_amount_b = 10
    min_price = 1.5
    max_price = 2.5

    %{
      liquidity_pool_id: liquidity_pool_id,
      max_amount_a: max_amount_a,
      max_amount_b: max_amount_b,
      min_price: min_price,
      max_price: max_price,
      xdr:
        XDRFixtures.liquidity_pool_deposit(
          liquidity_pool_id,
          max_amount_a,
          max_amount_b,
          min_price,
          max_price
        )
    }
  end

  test "new/2", %{
    liquidity_pool_id: liquidity_pool_id,
    max_amount_a: max_amount_a,
    max_amount_b: max_amount_b,
    min_price: min_price,
    max_price: max_price
  } do
    liquidity_pool_id_str = PoolID.new(liquidity_pool_id)
    max_amount_a_str = Amount.new(max_amount_a)
    max_amount_b_str = Amount.new(max_amount_b)
    min_price_str = Price.new(min_price)
    max_price_str = Price.new(max_price)

    %LiquidityPoolDeposit{
      liquidity_pool_id: ^liquidity_pool_id_str,
      max_amount_a: ^max_amount_a_str,
      max_amount_b: ^max_amount_b_str,
      min_price: ^min_price_str,
      max_price: ^max_price_str
    } =
      LiquidityPoolDeposit.new(
        liquidity_pool_id: liquidity_pool_id,
        max_amount_a: max_amount_a,
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: max_price
      )
  end

  test "new/2 with_invalid_pool_id", %{
    max_amount_a: max_amount_a,
    max_amount_b: max_amount_b,
    min_price: min_price,
    max_price: max_price
  } do
    {:error, [liquidity_pool_id: :invalid_pool_id]} =
      LiquidityPoolDeposit.new(
        liquidity_pool_id: "ID",
        max_amount_a: max_amount_a,
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: max_price
      )
  end

  test "new/2 with_invalid_amount", %{
    liquidity_pool_id: liquidity_pool_id,
    max_amount_b: max_amount_b,
    min_price: min_price,
    max_price: max_price
  } do
    {:error, [max_amount_a: :invalid_amount]} =
      LiquidityPoolDeposit.new(
        liquidity_pool_id: liquidity_pool_id,
        max_amount_a: "123",
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: max_price
      )
  end

  test "new/2 with_invalid_price", %{
    liquidity_pool_id: liquidity_pool_id,
    max_amount_a: max_amount_a,
    max_amount_b: max_amount_b,
    min_price: min_price
  } do
    {:error, [max_price: :invalid_price]} =
      LiquidityPoolDeposit.new(
        liquidity_pool_id: liquidity_pool_id,
        max_amount_a: max_amount_a,
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: "2.5"
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = LiquidityPoolDeposit.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    liquidity_pool_id: liquidity_pool_id,
    max_amount_a: max_amount_a,
    max_amount_b: max_amount_b,
    min_price: min_price,
    max_price: max_price
  } do
    ^xdr =
      [
        liquidity_pool_id: liquidity_pool_id,
        max_amount_a: max_amount_a,
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: max_price
      ]
      |> LiquidityPoolDeposit.new()
      |> LiquidityPoolDeposit.to_xdr()
  end
end
