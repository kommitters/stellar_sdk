defmodule Stellar.TxBuild.Ledger.ClaimableBalanceTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{ClaimableBalanceID, Ledger.ClaimableBalance}

  setup do
    claimable_balance_id =
      "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    %{
      claimable_balance_id: claimable_balance_id,
      xdr: XDRFixtures.ledger_claimable_balance(claimable_balance_id)
    }
  end

  test "new/2", %{claimable_balance_id: claimable_balance_id} do
    %ClaimableBalance{
      claimable_balance_id: %ClaimableBalanceID{
        balance_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        type: :v0
      }
    } = ClaimableBalance.new(claimable_balance_id)
  end

  test "new/2 invalid_claimable_balance_id" do
    {:error, :invalid_balance_id} = ClaimableBalance.new("ABCD")
  end

  test "to_xdr/1", %{xdr: xdr, claimable_balance_id: claimable_balance_id} do
    ^xdr =
      claimable_balance_id
      |> ClaimableBalance.new()
      |> ClaimableBalance.to_xdr()
  end
end
