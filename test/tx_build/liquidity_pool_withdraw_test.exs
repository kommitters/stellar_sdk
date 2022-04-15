defmodule Stellar.TxBuild.LiquidityPoolWithdrawTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{Amount, LiquidityPoolWithdraw, PoolID}

  setup do
    liquidity_pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"
    amount = 100
    min_amount_a = 20
    min_amount_b = 10

    %{
      liquidity_pool_id: liquidity_pool_id,
      amount: amount,
      min_amount_a: min_amount_a,
      min_amount_b: min_amount_b,
      xdr:
        XDRFixtures.liquidity_pool_withdraw(liquidity_pool_id, amount, min_amount_a, min_amount_b)
    }
  end

  test "new/2", %{
    liquidity_pool_id: liquidity_pool_id,
    amount: amount,
    min_amount_a: min_amount_a,
    min_amount_b: min_amount_b
  } do
    liquidity_pool_id_str = PoolID.new(liquidity_pool_id)
    amount_str = Amount.new(amount)
    min_amount_a_str = Amount.new(min_amount_a)
    min_amount_b_str = Amount.new(min_amount_b)

    %LiquidityPoolWithdraw{
      liquidity_pool_id: ^liquidity_pool_id_str,
      amount: ^amount_str,
      min_amount_a: ^min_amount_a_str,
      min_amount_b: ^min_amount_b_str
    } =
      LiquidityPoolWithdraw.new(
        liquidity_pool_id: liquidity_pool_id,
        amount: amount,
        min_amount_a: min_amount_a,
        min_amount_b: min_amount_b
      )
  end

  test "new/2 with_invalid_pool_id", %{
    amount: amount,
    min_amount_a: min_amount_a,
    min_amount_b: min_amount_b
  } do
    {:error, [liquidity_pool_id: :invalid_pool_id]} =
      LiquidityPoolWithdraw.new(
        liquidity_pool_id: "ID",
        amount: amount,
        min_amount_a: min_amount_a,
        min_amount_b: min_amount_b
      )
  end

  test "new/2 with_invalid_amount", %{
    liquidity_pool_id: liquidity_pool_id,
    min_amount_a: min_amount_a,
    min_amount_b: min_amount_b
  } do
    {:error, [amount: :invalid_amount]} =
      LiquidityPoolWithdraw.new(
        liquidity_pool_id: liquidity_pool_id,
        amount: "ABC",
        min_amount_a: min_amount_a,
        min_amount_b: min_amount_b
      )
  end

  test "new/2 with_invalid_min_amount", %{
    liquidity_pool_id: liquidity_pool_id,
    amount: amount,
    min_amount_b: min_amount_b
  } do
    {:error, [min_amount_a: :invalid_amount]} =
      LiquidityPoolWithdraw.new(
        liquidity_pool_id: liquidity_pool_id,
        amount: amount,
        min_amount_a: "ABC",
        min_amount_a: min_amount_b
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = LiquidityPoolWithdraw.new("ABC", "123")
  end

  test "to_xdr/1", %{
    xdr: xdr,
    liquidity_pool_id: liquidity_pool_id,
    amount: amount,
    min_amount_a: min_amount_a,
    min_amount_b: min_amount_b
  } do
    ^xdr =
      [
        liquidity_pool_id: liquidity_pool_id,
        amount: amount,
        min_amount_a: min_amount_a,
        min_amount_b: min_amount_b
      ]
      |> LiquidityPoolWithdraw.new()
      |> LiquidityPoolWithdraw.to_xdr()
  end
end
