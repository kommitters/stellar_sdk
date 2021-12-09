defmodule Stellar.TxBuild.BaseFeeTest do
  use ExUnit.Case

  alias StellarBase.XDR.UInt32
  alias Stellar.TxBuild.BaseFee

  test "new/2" do
    %BaseFee{fee: 100, multiplier: 1} = BaseFee.new()
  end

  test "new/2 invalid_values" do
    {:error, :invalid_fee} = BaseFee.new(500, "a")
  end

  test "to_xdr/1" do
    %UInt32{datum: 1_500} = BaseFee.new(500, 3) |> BaseFee.to_xdr()
  end
end
