defmodule Stellar.TxBuild.UtilsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Utils

  test "float_to_fraction/1" do
    {43, 20} = Utils.number_to_fraction(2.15)
  end

  test "number_to_fraction/1 integer" do
    {2, 1} = Utils.number_to_fraction(2)
  end

  test "number_to_fraction/1 error" do
    assert_raise FunctionClauseError,
                 "no function clause matching in Stellar.TxBuild.Utils.number_to_fraction/1",
                 fn ->
                   Utils.number_to_fraction("2.15")
                 end
  end
end
