defmodule Stellar.TxBuild.OptionalFlagsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{Flags, OptionalFlags}
  alias StellarBase.XDR.{OptionalUInt32, UInt32}

  setup do
    %{flags: Flags.new([:revocable, :inmutable])}
  end

  test "new/2", %{flags: flags} do
    %OptionalFlags{flags: ^flags} = OptionalFlags.new(flags)
  end

  test "new/2 without_flags" do
    %OptionalFlags{flags: nil} = OptionalFlags.new()
  end

  test "to_xdr/1", %{flags: flags} do
    %OptionalUInt32{datum: %UInt32{datum: 6}} =
      flags
      |> OptionalFlags.new()
      |> OptionalFlags.to_xdr()
  end

  test "to_xdr/1 without_flags" do
    %OptionalUInt32{datum: nil} =
      nil
      |> OptionalFlags.new()
      |> OptionalFlags.to_xdr()
  end
end
