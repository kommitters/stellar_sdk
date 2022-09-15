defmodule Stellar.Horizon.Operation.CreateClaimableBalanceTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.CreateClaimableBalance

  setup do
    %{
      attrs: %{
        asset: "NGNT:GAWODAROMJ33V5YDFY3NPYTHVYQG7MJXVJ2ND3AOGIHYRWINES6ACCPD",
        amount: "200.0000000",
        claimants: [
          %{
            destination: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML",
            predicate: %{
              and: [
                %{
                  or: [
                    %{
                      relBefore: "12"
                    },
                    %{
                      absBefore: "2020-08-26T11:15:39Z",
                      absBeforeEpoch: "1598440539"
                    }
                  ]
                },
                %{
                  not: %{unconditional: true}
                }
              ]
            }
          }
        ]
      }
    }
  end

  test "new/2", %{attrs: %{asset: asset, amount: amount, claimants: claimants} = attrs} do
    %CreateClaimableBalance{asset: ^asset, amount: ^amount, claimants: ^claimants} =
      CreateClaimableBalance.new(attrs)
  end

  test "new/2 empty_attrs" do
    %CreateClaimableBalance{asset: nil, amount: nil, claimants: nil} =
      CreateClaimableBalance.new(%{})
  end
end
