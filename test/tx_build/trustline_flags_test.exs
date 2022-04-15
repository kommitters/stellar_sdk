defmodule Stellar.TxBuild.TrustlineFlagsTest do
  use ExUnit.Case

  alias Stellar.TxBuild.TrustlineFlags
  alias StellarBase.XDR.UInt32

  setup do
    %{flags: [:authorized, :maintain_liabilities]}
  end

  test "new/2", %{flags: flags} do
    %TrustlineFlags{value: 3} = TrustlineFlags.new(flags)
  end

  test "new/2 required" do
    %TrustlineFlags{value: 1} = TrustlineFlags.new([:authorized])
  end

  test "new/2 revocable" do
    %TrustlineFlags{value: 2} = TrustlineFlags.new([:maintain_liabilities])
  end

  test "new/2 with_bad_arguments" do
    %TrustlineFlags{value: 0} = TrustlineFlags.new([:test, :auth])
  end

  test "new/2 with_invalid_arguments" do
    {:error, :invalid_flags} = TrustlineFlags.new(:auth, :test)
  end

  test "to_xdr/1", %{flags: flags} do
    %UInt32{datum: 3} =
      flags
      |> TrustlineFlags.new()
      |> TrustlineFlags.to_xdr()
  end
end
