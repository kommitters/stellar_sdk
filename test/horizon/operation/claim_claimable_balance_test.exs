defmodule Stellar.Horizon.Operation.ClaimClaimableBalanceTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.ClaimClaimableBalance

  setup do
    %{
      attrs: %{
        balance_id: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        claimant: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML"
      }
    }
  end

  test "new/2", %{attrs: %{balance_id: balance_id, claimant: claimant} = attrs} do
    %ClaimClaimableBalance{balance_id: ^balance_id, claimant: ^claimant} =
      ClaimClaimableBalance.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ClaimClaimableBalance{balance_id: nil, claimant: nil} = ClaimClaimableBalance.new(%{})
  end
end
