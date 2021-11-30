defmodule Stellar.TxBuild.AmountTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Amount
  alias StellarBase.XDR.Int64

  test "new/2 integer" do
    %Amount{amount: 7, raw_amount: 70_000_000} = Amount.new(7)
  end

  test "new/2 float" do
    %Amount{amount: 3.141516, raw_amount: 31_415_160} = Amount.new(3.141516)
  end

  test "new/2 invalid" do
    {:error, :invalid_amount} = Amount.new("123")
  end

  test "to_xdr/1" do
    amount_xdr = Int64.new(70_000_000)

    ^amount_xdr =
      7
      |> Amount.new()
      |> Amount.to_xdr()
  end
end
