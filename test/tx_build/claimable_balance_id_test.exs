defmodule Stellar.TxBuild.ClaimableBalanceIDTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.ClaimableBalanceID

  setup do
    balance_id = "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    %{
      balance_id: balance_id,
      xdr: XDRFixtures.claimable_balance_id(balance_id)
    }
  end

  test "new/2", %{balance_id: balance_id} do
    %ClaimableBalanceID{
      balance_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
      type: :v0
    } = ClaimableBalanceID.new(balance_id)
  end

  test "new/2 invalid_balance_id" do
    {:error, :invalid_balance_id} = ClaimableBalanceID.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, balance_id: balance_id} do
    ^xdr =
      balance_id
      |> ClaimableBalanceID.new()
      |> ClaimableBalanceID.to_xdr()
  end
end
