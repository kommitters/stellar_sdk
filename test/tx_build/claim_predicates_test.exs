defmodule Stellar.TxBuild.ClaimPredicatesTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{ClaimPredicate, ClaimPredicates}

  setup do
    predicate1 = ClaimPredicate.new(:unconditional)
    predicate2 = ClaimPredicate.new(value: 1, type: :time, time_type: :absolute)

    predicates = [predicate1, predicate2]

    %{
      predicates: predicates,
      xdr: XDRFixtures.claim_predicates(predicates)
    }
  end

  test "new/2", %{predicates: predicates} do
    %ClaimPredicates{value: ^predicates} = ClaimPredicates.new(predicates)
  end

  test "new/2 invalid_predicate_list" do
    {:error, :invalid_predicate_list_value} = ClaimPredicates.new([1, 2])
  end

  test "to_xdr/1", %{predicates: value, xdr: xdr} do
    ^xdr =
      value
      |> ClaimPredicates.new()
      |> ClaimPredicates.to_xdr()
  end
end
