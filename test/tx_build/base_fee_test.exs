defmodule Stellar.TxBuild.BaseFeeTest do
  use ExUnit.Case

  alias StellarBase.XDR.UInt32
  alias Stellar.TxBuild.BaseFee

  test "new/2" do
    %BaseFee{fee: 400} = BaseFee.new(4)
  end

  test "new/2 no_operations" do
    %BaseFee{fee: 100} = BaseFee.new()
  end

  test "new/2 invalid_values" do
    {:error, :invalid_fee} = BaseFee.new("500")
  end

  test "to_xdr/1" do
    %UInt32{datum: 100} = BaseFee.new() |> BaseFee.to_xdr()
  end

  test "to_xdr/1 with_multiplier" do
    %UInt32{datum: 500} =
      5
      |> BaseFee.new()
      |> BaseFee.to_xdr()
  end
end
