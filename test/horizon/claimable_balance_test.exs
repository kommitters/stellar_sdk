defmodule Stellar.Horizon.ClaimableBalanceTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.ClaimableBalance

  setup do
    json_body = Horizon.fixture("claimable_balance")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %ClaimableBalance{
      id: "00000000929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
      asset: "native",
      amount: 10.0000000,
      claimants: [
        %{
          destination: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML",
          predicate: %{
            and: [
              _predicate,
              %{
                not: %{unconditional: true}
              }
            ]
          }
        }
      ],
      last_modified_ledger: 28_411_995,
      last_modified_time: ~U[2020-02-26 19:29:16Z]
    } = ClaimableBalance.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ClaimableBalance{
      id: nil,
      asset: nil,
      amount: nil,
      claimants: nil,
      last_modified_ledger: nil,
      last_modified_time: nil
    } = ClaimableBalance.new(%{})
  end
end
