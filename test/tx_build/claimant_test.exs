defmodule Stellar.TxBuild.ClaimantTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{ClaimPredicate, Claimant, AccountID}

  setup do
    destination = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    predicate1 = ClaimPredicate.new(:unconditional)

    predicate2 =
      ClaimPredicate.new(
        value: predicate1,
        type: :not
      )

    %{
      destination: destination,
      predicate_unconditional: predicate1,
      predicate: predicate2,
      xdr_claimant: XDRFixtures.claimant(destination, predicate2)
    }
  end

  test "new/2", %{destination: destination, predicate: predicate} do
    destination_str = AccountID.new(destination)

    %Claimant{destination: ^destination_str, predicate: ^predicate} =
      Claimant.new(destination: destination, predicate: predicate)
  end

  test "new/2 tuple_with_arguments", %{destination: destination, predicate: predicate} do
    destination_str = AccountID.new(destination)

    %Claimant{destination: ^destination_str, predicate: ^predicate} =
      Claimant.new({destination, predicate})
  end

  test "new/2 unconditional_predicate", %{
    destination: destination,
    predicate_unconditional: predicate
  } do
    destination_str = AccountID.new(destination)

    %Claimant{destination: ^destination_str, predicate: ^predicate} =
      Claimant.new(destination: destination, predicate: predicate)
  end

  test "new/2 invalid_claimant" do
    {:error, :invalid_claimant} = Claimant.new("ABC", "ABC")
  end

  test "new/2 invalid_ed25519_public_key", %{predicate: predicate} do
    {:error, [destination: :invalid_ed25519_public_key]} =
      Claimant.new(destination: "ABC", predicate: predicate)
  end

  test "new/2 invalid_claim_predicate", %{destination: destination} do
    {:error, :invalid_claim_predicate} = Claimant.new(destination: destination, predicate: "ABC")
  end

  test "to_xdr/1 time_absolute", %{
    destination: destination,
    predicate: predicate,
    xdr_claimant: xdr
  } do
    ^xdr =
      [destination: destination, predicate: predicate]
      |> Claimant.new()
      |> Claimant.to_xdr()
  end
end
