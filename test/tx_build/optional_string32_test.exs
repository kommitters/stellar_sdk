defmodule Stellar.TxBuild.OptionalString32Test do
  use ExUnit.Case

  alias Stellar.TxBuild.{String32, OptionalString32}
  alias StellarBase.XDR.OptionalString32, as: OptionalString32XDR
  alias StellarBase.XDR.String32, as: String32XDR

  setup do
    %{string32: String32.new("HELLO")}
  end

  test "new/2", %{string32: string32} do
    %OptionalString32{value: ^string32} = OptionalString32.new(string32)
  end

  test "new/2 without_value" do
    %OptionalString32{value: nil} = OptionalString32.new()
  end

  test "to_xdr/1", %{string32: string32} do
    %OptionalString32XDR{value: %String32XDR{value: "HELLO"}} =
      string32
      |> OptionalString32.new()
      |> OptionalString32.to_xdr()
  end

  test "to_xdr/1 without_value" do
    %OptionalString32XDR{value: nil} =
      nil
      |> OptionalString32.new()
      |> OptionalString32.to_xdr()
  end
end
