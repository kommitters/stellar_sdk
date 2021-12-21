defmodule Stellar.TxBuild.FlagsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Flags
  alias StellarBase.XDR.UInt32

  setup do
    %{flags: [:required, :revocable, :inmutable, :clawback_enabled]}
  end

  test "new/2", %{flags: flags} do
    %Flags{value: 15} = Flags.new(flags)
  end

  test "new/2 required" do
    %Flags{value: 1} = Flags.new([:required])
  end

  test "new/2 revocable" do
    %Flags{value: 2} = Flags.new([:revocable])
  end

  test "new/2 inmutable" do
    %Flags{value: 4} = Flags.new([:inmutable])
  end

  test "new/2 clawback_enabled" do
    %Flags{value: 8} = Flags.new([:clawback_enabled])
  end

  test "new/2 with_bad_arguments" do
    %Flags{value: 0} = Flags.new([:test, :auth])
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_flags} = Flags.new(:auth, :test)
  end

  test "to_xdr/1", %{flags: flags} do
    %UInt32{datum: 15} =
      flags
      |> Flags.new()
      |> Flags.to_xdr()
  end
end
