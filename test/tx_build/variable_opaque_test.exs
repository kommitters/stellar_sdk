defmodule Stellar.TxBuild.VariableOpaqueTest do
  use ExUnit.Case

  alias StellarBase.XDR.VariableOpaque, as: VariableOpaqueXDR
  alias Stellar.TxBuild.VariableOpaque

  setup do
    %{value: :crypto.strong_rand_bytes(32)}
  end

  test "new/2" do
    %VariableOpaque{value: "TEST"} = VariableOpaque.new("TEST")
  end

  test "new/2 with_non_string_value" do
    {:error, :invalid_opaque} = VariableOpaque.new(10)
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_opaque} = VariableOpaque.new(:weight, 200)
  end

  test "to_xdr/1" do
    %VariableOpaqueXDR{opaque: "TEST"} =
      "TEST"
      |> VariableOpaque.new()
      |> VariableOpaque.to_xdr()
  end

  test "to_xdr/1 error" do
    {:error, :invalid_struct} = VariableOpaque.to_xdr(:invalid)
  end
end
