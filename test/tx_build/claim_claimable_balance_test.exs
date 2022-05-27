defmodule Stellar.TxBuild.ClaimClaimableBalanceTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{ClaimableBalanceID, ClaimClaimableBalance}

  setup do
    balance_id = "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072"

    %{
      balance_id: balance_id,
      claimable_balance_id: ClaimableBalanceID.new(balance_id),
      xdr: XDRFixtures.claim_claimable_balance(balance_id)
    }
  end

  test "new/2", %{balance_id: balance_id, claimable_balance_id: claimable_balance_id} do
    %ClaimClaimableBalance{claimable_balance_id: ^claimable_balance_id} =
      ClaimClaimableBalance.new(claimable_balance_id: balance_id)
  end

  test "new/2 with_invalid_balance_id" do
    {:error, [claimable_balance_id: :invalid_balance_id]} =
      ClaimClaimableBalance.new(claimable_balance_id: 123)
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = ClaimClaimableBalance.new("ABC", "123")
  end

  test "to_xdr/1", %{xdr: xdr, balance_id: balance_id} do
    ^xdr =
      [claimable_balance_id: balance_id]
      |> ClaimClaimableBalance.new()
      |> ClaimClaimableBalance.to_xdr()
  end
end
