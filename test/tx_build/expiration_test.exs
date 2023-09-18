defmodule Stellar.TxBuild.Ledger.ExpirationTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Ledger.Expiration

  setup do
    hash = "hash_value"

    %{
      hash: hash
    }
  end

  test "new/2", %{hash: hash} do
    %Expiration{key_hash: ^hash} = Expiration.new(hash)
  end

  test "new/2 with invalid key hash" do
    {:error, :invalid_expiration} = Expiration.new(:invalid_hash)
  end

  test "to_xdr/1", %{hash: hash} do
    %StellarBase.XDR.LedgerKeyExpiration{key_hash: %StellarBase.XDR.Hash{value: "hash_value"}} =
      Expiration.new(hash) |> Expiration.to_xdr()
  end

  test "to_xdr/1 with invalid Expiration" do
    {:error, :invalid_struct} = Expiration.to_xdr("invalid_expiration")
  end
end
