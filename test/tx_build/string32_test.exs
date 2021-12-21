defmodule Stellar.TxBuild.String32Test do
  use ExUnit.Case

  alias Stellar.TxBuild.String32
  alias StellarBase.XDR.String32, as: String32XDR

  test "new/2" do
    %String32{value: "TEST"} = String32.new("TEST")
  end

  test "new/2 with_non_string_value" do
    {:error, :invalid_string} = String32.new(10)
  end

  test "new/2 exceed_upper_bounds" do
    {:error, :invalid_string} = String32.new("THIS IS A REALLY LONG TEST PHRASE")
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_string} = String32.new(:weight, 200)
  end

  test "to_xdr/1" do
    %String32XDR{value: "TEST"} =
      "TEST"
      |> String32.new()
      |> String32.to_xdr()
  end
end
