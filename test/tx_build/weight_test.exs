defmodule Stellar.TxBuild.WeightTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Weight
  alias StellarBase.XDR.UInt32

  test "new/2" do
    %Weight{value: 15} = Weight.new(15)
  end

  test "new/2 exceed_lower_bounds" do
    {:error, :invalid_weight} = Weight.new(-1)
  end

  test "new/2 exceed_upper_bounds" do
    {:error, :invalid_weight} = Weight.new(256)
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_weight} = Weight.new(:weight, 200)
  end

  test "to_xdr/1" do
    %UInt32{datum: 200} =
      200
      |> Weight.new()
      |> Weight.to_xdr()
  end
end
