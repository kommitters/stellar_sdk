defmodule Stellar.TxBuild.ClaimPredicateTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.ClaimPredicate

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

    predicate2 =
      ClaimPredicate.new(
        value: [predicate_unconditional, predicate_relative],
        type: :or
      )

    predicates = [predicate1, predicate2]

    %{
      value_time: value_time,
      predicates: predicates,
      predicate: predicate1,
      xdr_unconditional: XDRFixtures.predicate_unconditional(:unconditional),
      xdr_and: XDRFixtures.predicate_and(predicates, :and),
      xdr_or: XDRFixtures.predicate_or(predicates, :or),
      xdr_not: XDRFixtures.predicate_not(predicate1, :not),
      xdr_time_absolute: XDRFixtures.predicate_time_absolute(value_time, :time, :absolute),
      xdr_time_relative: XDRFixtures.predicate_time_relative(value_time, :time, :relative)
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
    {:error, :invalid_predicate_list_value} = ClaimPredicate.new(value: [predicate, 1], type: :or)
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
