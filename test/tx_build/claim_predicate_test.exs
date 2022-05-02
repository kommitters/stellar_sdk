defmodule Stellar.TxBuild.ClaimPredicateTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{ClaimPredicate, ClaimPredicates}

  setup do
    value_time = 1
    predicate_unconditional = ClaimPredicate.new(:unconditional)
    predicate_absolute = ClaimPredicate.new(value: 1, type: :time, time_type: :absolute)
    predicate_relative = ClaimPredicate.new(value: 2, type: :time, time_type: :relative)

    predicate1 =
      ClaimPredicate.new(
        value: predicate_absolute,
        type: :not
      )

    predicates = [predicate1, predicate_relative]
    claim_predicates = ClaimPredicates.new(predicates)

    %{
      value_time: value_time,
      predicates: claim_predicates,
      predicate: predicate_unconditional,
      xdr_unconditional: XDRFixtures.claim_predicate_unconditional(:unconditional),
      xdr_and: XDRFixtures.claim_predicate_and(claim_predicates, :and),
      xdr_or: XDRFixtures.claim_predicate_or(claim_predicates, :or),
      xdr_not: XDRFixtures.claim_predicate_not(predicate_unconditional, :not),
      xdr_time_absolute: XDRFixtures.claim_predicate_time_absolute(value_time, :time, :absolute),
      xdr_time_relative: XDRFixtures.claim_predicate_time_relative(value_time, :time, :relative)
    }
  end

  test "new/2 unconditional_predicate" do
    %ClaimPredicate{predicate: :unconditional} = ClaimPredicate.new(:unconditional)
  end

  test "new/2 and_type", %{predicates: predicates} do
    %ClaimPredicate{predicate: :conditional, value: ^predicates, type: :and} =
      ClaimPredicate.new(value: predicates, type: :and)
  end

  test "new/2 and_type_invalid", %{value_time: value_time} do
    {:error, :invalid_predicate_value} = ClaimPredicate.new(value: value_time, type: :and)
  end

  test "new/2 or_type", %{predicates: predicates} do
    %ClaimPredicate{predicate: :conditional, value: ^predicates, type: :or} =
      ClaimPredicate.new(value: predicates, type: :or)
  end

  test "new/2 or_type_invalid", %{value_time: value_time} do
    {:error, :invalid_predicate_value} = ClaimPredicate.new(value: value_time, type: :or)
  end

  test "new/2 invalid_predicate_value", %{predicate: predicate} do
    {:error, :invalid_predicate_list_value} = ClaimPredicates.new([predicate, 1])
  end

  test "new/2 not_type", %{predicate: predicate} do
    %ClaimPredicate{
      predicate: :conditional,
      value: ^predicate,
      type: :not
    } = ClaimPredicate.new(value: predicate, type: :not)
  end

  test "new/2 not_type_invalid", %{predicates: predicates} do
    {:error, :invalid_predicate_value} = ClaimPredicate.new(value: predicates, type: :not)
  end

  test "new/2 time_type_absolute", %{value_time: value} do
    %ClaimPredicate{
      predicate: :conditional,
      value: ^value,
      type: :time,
      time_type: :absolute
    } = ClaimPredicate.new(value: value, type: :time, time_type: :absolute)
  end

  test "new/2 time_type_absolute_invalid", %{predicate: predicate} do
    {:error, :invalid_predicate_value} =
      ClaimPredicate.new(value: predicate, type: :time, time_type: :absolute)
  end

  test "new/2 time_type_relative", %{value_time: value} do
    %ClaimPredicate{
      predicate: :conditional,
      value: ^value,
      type: :time,
      time_type: :relative
    } = ClaimPredicate.new(value: value, type: :time, time_type: :relative)
  end

  test "new/2 time_type_relative_invalid", %{predicates: predicates} do
    {:error, :invalid_predicate_value} =
      ClaimPredicate.new(value: predicates, type: :time, time_type: :relative)
  end

  test "to_xdr/1 unconditional", %{xdr_unconditional: xdr} do
    ^xdr =
      :unconditional
      |> ClaimPredicate.new()
      |> ClaimPredicate.to_xdr()
  end

  test "to_xdr/1 and", %{predicates: value, xdr_and: xdr} do
    ^xdr =
      [value: value, type: :and]
      |> ClaimPredicate.new()
      |> ClaimPredicate.to_xdr()
  end

  test "to_xdr/1 or", %{predicates: value, xdr_or: xdr} do
    ^xdr =
      [value: value, type: :or]
      |> ClaimPredicate.new()
      |> ClaimPredicate.to_xdr()
  end

  test "to_xdr/1 not", %{predicate: value, xdr_not: xdr} do
    ^xdr =
      [value: value, type: :not]
      |> ClaimPredicate.new()
      |> ClaimPredicate.to_xdr()
  end

  test "to_xdr/1 time_absolute", %{value_time: value, xdr_time_absolute: xdr} do
    ^xdr =
      [value: value, type: :time, time_type: :absolute]
      |> ClaimPredicate.new()
      |> ClaimPredicate.to_xdr()
  end

  test "to_xdr/1 time_relative", %{value_time: value, xdr_time_relative: xdr} do
    ^xdr =
      [value: value, type: :time, time_type: :relative]
      |> ClaimPredicate.new()
      |> ClaimPredicate.to_xdr()
  end
end
