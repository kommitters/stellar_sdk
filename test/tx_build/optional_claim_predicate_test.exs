defmodule Stellar.TxBuild.OptionalClaimPredicateTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{ClaimPredicate, OptionalClaimPredicate}

  setup do
    predicate = ClaimPredicate.new(:unconditional)

    %{
      predicate: predicate,
      xdr: XDRFixtures.optional_predicate(predicate)
    }
  end

  test "new/2", %{predicate: predicate} do
    %OptionalClaimPredicate{value: ^predicate} = OptionalClaimPredicate.new(predicate)
  end

  test "new/2 invalid_optional_claim_predicate" do
    {:error, :invalid_optional_claim_predicate} = OptionalClaimPredicate.new(1)
  end

  test "to_xdr/1", %{predicate: value, xdr: xdr} do
    ^xdr =
      value
      |> OptionalClaimPredicate.new()
      |> OptionalClaimPredicate.to_xdr()
  end
end
