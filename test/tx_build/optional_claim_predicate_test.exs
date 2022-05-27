defmodule Stellar.TxBuild.OptionalClaimPredicateTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{ClaimPredicate, OptionalClaimPredicate}

  setup do
    predicate = ClaimPredicate.new(:unconditional)

    %{
      predicate: predicate,
      xdr: XDRFixtures.optional_predicate(predicate),
      xdr_nil: XDRFixtures.optional_predicate_with_nil_value(nil)
    }
  end

  test "new/2", %{predicate: predicate} do
    %OptionalClaimPredicate{value: ^predicate} = OptionalClaimPredicate.new(predicate)
  end

  test "new/2 with_nil_value" do
    %OptionalClaimPredicate{value: nil} = OptionalClaimPredicate.new(nil)
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

  test "to_xdr/1 with_nil_value", %{xdr_nil: xdr} do
    ^xdr =
      nil
      |> OptionalClaimPredicate.new()
      |> OptionalClaimPredicate.to_xdr()
  end
end
