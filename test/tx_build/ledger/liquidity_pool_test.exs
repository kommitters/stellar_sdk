defmodule Stellar.TxBuild.Ledger.LiquidityPoolTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{PoolID, Ledger.LiquidityPool}

  setup do
    liquidity_pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    %{
      liquidity_pool_id: liquidity_pool_id,
      xdr: XDRFixtures.ledger_liquidity_pool(liquidity_pool_id)
    }
  end

  test "new/2", %{liquidity_pool_id: liquidity_pool_id} do
    %LiquidityPool{liquidity_pool_id: %PoolID{pool_id: ^liquidity_pool_id}} =
      LiquidityPool.new(liquidity_pool_id)
  end

  test "new/2 invalid_liquidity_pool_id" do
    {:error, :invalid_pool_id} = LiquidityPool.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, liquidity_pool_id: liquidity_pool_id} do
    ^xdr =
      liquidity_pool_id
      |> LiquidityPool.new()
      |> LiquidityPool.to_xdr()
  end
end
