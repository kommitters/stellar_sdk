defmodule Stellar.TxBuild.ClaimantsTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{ClaimPredicate, Claimant, Claimants}

  setup do
    destination = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"

    predicate1 = ClaimPredicate.new(:unconditional)

    predicate2 =
      ClaimPredicate.new(
        value: predicate1,
        type: :not
      )

    claimant1 = Claimant.new(destination: destination, predicate: predicate1)
    claimant2 = Claimant.new(destination: destination, predicate: predicate2)
    claimants = [claimant1, claimant2]

    %{
      claimants: claimants,
      xdr_claimants: XDRFixtures.claimants(claimants)
    }
  end

  test "new/2", %{claimants: claimants} do
    %Claimants{claimants: ^claimants} = Claimants.new(claimants)
  end

  test "new/2 invalid_claimant" do
    {:error, :invalid_claimant} = Claimants.new(["test1", "test2"])
  end

  test "to_xdr/1", %{claimants: claimants, xdr_claimants: xdr} do
    ^xdr =
      claimants
      |> Claimants.new()
      |> Claimants.to_xdr()
  end
end
