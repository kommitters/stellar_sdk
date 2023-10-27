defmodule Stellar.TxBuild.Ledger.TTLTest do
  use ExUnit.Case

  alias Stellar.TxBuild.Ledger.TTL

  setup do
    hash = "hash_value"

    %{
      hash: hash
    }
  end

  test "new/2", %{hash: hash} do
    %TTL{key_hash: ^hash} = TTL.new(hash)
  end

  test "new/2 with invalid key hash" do
    {:error, :invalid_ttl} = TTL.new(:invalid_hash)
  end

  test "to_xdr/1", %{hash: hash} do
    %StellarBase.XDR.LedgerKeyTTL{key_hash: %StellarBase.XDR.Hash{value: "hash_value"}} =
      TTL.new(hash) |> TTL.to_xdr()
  end

  test "to_xdr/1 with invalid TTL" do
    {:error, :invalid_struct} = TTL.to_xdr("invalid_ttl")
  end
end
