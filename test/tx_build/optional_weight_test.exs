defmodule Stellar.TxBuild.OptionalWeightTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Weight, OptionalWeight}
  alias StellarBase.XDR.{OptionalUInt32, UInt32}

  setup do
    %{weight: Weight.new(2)}
  end

  test "new/2", %{weight: weight} do
    %OptionalWeight{weight: ^weight} = OptionalWeight.new(weight)
  end

  test "new/2 without_weight" do
    %OptionalWeight{weight: nil} = OptionalWeight.new()
  end

  test "to_xdr/1", %{weight: weight} do
    %OptionalUInt32{datum: %UInt32{datum: 2}} =
      weight
      |> OptionalWeight.new()
      |> OptionalWeight.to_xdr()
  end

  test "to_xdr/1 without_weight" do
    %OptionalUInt32{datum: nil} =
      nil
      |> OptionalWeight.new()
      |> OptionalWeight.to_xdr()
  end
end
