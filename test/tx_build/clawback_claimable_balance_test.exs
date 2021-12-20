defmodule Stellar.TxBuild.ClawbackClaimableBalanceTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [clawback_claimable_balance_op_xdr: 1]

  alias Stellar.TxBuild.{ClaimableBalanceID, ClawbackClaimableBalance}

  setup do
    balance_id = "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    %{
      balance_id: balance_id,
      claimable_balance_id: ClaimableBalanceID.new(balance_id),
      xdr: clawback_claimable_balance_op_xdr(balance_id)
    }
  end

  test "new/2", %{balance_id: balance_id, claimable_balance_id: claimable_balance_id} do
    %ClawbackClaimableBalance{claimable_balance_id: ^claimable_balance_id} =
      ClawbackClaimableBalance.new(claimable_balance_id: balance_id)
  end

  test "new/2 with_invalid_balance_id" do
    {:error, [claimable_balance_id: :invalid_balance_id]} =
      ClawbackClaimableBalance.new(claimable_balance_id: 123)
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = ClawbackClaimableBalance.new("ABC", "123")
  end

  test "to_xdr/1", %{xdr: xdr, balance_id: balance_id} do
    ^xdr =
      [claimable_balance_id: balance_id]
      |> ClawbackClaimableBalance.new()
      |> ClawbackClaimableBalance.to_xdr()
  end
end
