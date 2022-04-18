defmodule Stellar.TxBuild.PoolIDTest do
  use ExUnit.Case

  alias Stellar.TxBuild.PoolID
  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  setup do
    pool_id = "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    %{
      pool_id: pool_id,
      xdr: XDRFixtures.liquidity_pool_id(pool_id)
    }
  end

  test "new/2", %{pool_id: pool_id} do
    %PoolID{pool_id: ^pool_id} = PoolID.new(pool_id)
  end

  test "new/2 invalid_pool_id" do
    {:error, :invalid_pool_id} = PoolID.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, pool_id: pool_id} do
    ^xdr =
      pool_id
      |> PoolID.new()
      |> PoolID.to_xdr()
  end
end
