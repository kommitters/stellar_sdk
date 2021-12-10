defmodule Stellar.TxBuild.OptionalAccountTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [muxed_account_xdr: 1]

  alias Stellar.TxBuild.OptionalAccount
  alias StellarBase.XDR.OptionalMuxedAccount

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      account_id: account_id,
      muxed_account_xdr: muxed_account_xdr(account_id)
    }
  end

  test "new/2", %{account_id: account_id} do
    %OptionalAccount{account_id: ^account_id} = OptionalAccount.new(account_id)
  end

  test "new/2 without_account_id" do
    %OptionalAccount{account_id: nil} = OptionalAccount.new()
  end

  test "to_xdr/1", %{muxed_account_xdr: muxed_account_xdr, account_id: account_id} do
    %OptionalMuxedAccount{source_account: ^muxed_account_xdr} =
      account_id
      |> OptionalAccount.new()
      |> OptionalAccount.to_xdr()
  end

  test "to_xdr/1 without_account_id" do
    %OptionalMuxedAccount{source_account: nil} =
      nil
      |> OptionalAccount.new()
      |> OptionalAccount.to_xdr()
  end
end
