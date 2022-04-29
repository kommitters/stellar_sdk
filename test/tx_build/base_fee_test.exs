defmodule Stellar.TxBuild.BaseFeeTest do
  use ExUnit.Case

  alias StellarBase.XDR.UInt32
  alias Stellar.TxBuild.BaseFee

  test "new/2" do
    %BaseFee{fee: 400, multiplier: 0} = BaseFee.new(400)
  end

  test "new/2 no_operations" do
    %BaseFee{fee: 100, multiplier: 0} = BaseFee.new()
  end

  test "new/2 invalid_values" do
    {:error, :invalid_fee} = BaseFee.new("500")
  end

  test "increment/2" do
    %BaseFee{fee: 100, multiplier: 2} = BaseFee.new() |> BaseFee.increment(2)
  end

  test "increment/2 default_value" do
    %BaseFee{fee: 100, multiplier: 1} = BaseFee.new() |> BaseFee.increment()
  end

  test "increment/2 invalid_value" do
    {:error, :invalid_fee} = BaseFee.new() |> BaseFee.increment("4")
  end

  test "to_xdr/1" do
    %UInt32{datum: 500} =
      500
      |> BaseFee.new()
      |> BaseFee.to_xdr()
  end

  test "to_xdr/1 with_multiplier" do
    %UInt32{datum: 1_500} =
      500
      |> BaseFee.new()
      |> BaseFee.increment(3)
      |> BaseFee.to_xdr()
  end
end
