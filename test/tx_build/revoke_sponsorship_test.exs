defmodule Stellar.TxBuild.RevokeSponsorshipTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures
  alias Stellar.TxBuild.{LedgerKey, RevokeSponsorship, RevokeSponsorshipSigner}

  describe "ledger" do
    setup do
      account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

      %{
        account_id: account_id,
        ledger_key: LedgerKey.new({:account, [account_id: account_id]}),
        xdr: XDRFixtures.revoke_sponsorship(:account, account_id: account_id)
      }
    end

    test "new/2", %{account_id: account_id, ledger_key: ledger_key} do
      %RevokeSponsorship{sponsorship: ^ledger_key, type: :ledger_entry} =
        RevokeSponsorship.new(account: [account_id: account_id])
    end

    test "new/2 with_invalid_account" do
      {:error, :invalid_ledger_key} = RevokeSponsorship.new(account: [account_id: "ABC"])
    end

    test "new/2 with_invalid_sponsorship" do
      {:error, :invalid_sponsorship} = RevokeSponsorship.new(test: [account_id: "ABC"])
    end

    test "to_xdr/1", %{account_id: account_id, xdr: xdr} do
      ^xdr =
        [account: [account_id: account_id]]
        |> RevokeSponsorship.new()
        |> RevokeSponsorship.to_xdr()
    end
  end

  describe "signer" do
    setup do
      account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      ed25519_key = "GDAE7O3YJMC7COEZLPJY6OY3P6WGHSHA3QZH2B456JXV4VDEJRAUSA35"

      %{
        account_id: account_id,
        ed25519_key: ed25519_key,
        signer: RevokeSponsorshipSigner.new(account_id: account_id, ed25519: ed25519_key),
        xdr: XDRFixtures.revoke_sponsorship(:signer, account_id: account_id, ed25519: ed25519_key)
      }
    end

    test "new/2", %{account_id: account_id, ed25519_key: ed25519_key, signer: signer} do
      %RevokeSponsorship{sponsorship: ^signer, type: :signer} =
        RevokeSponsorship.new(signer: [account_id: account_id, ed25519: ed25519_key])
    end

    test "new/2 with_invalid_signer", %{account_id: account_id} do
      {:error, :invalid_signer} =
        RevokeSponsorship.new(signer: [account_id: account_id, ed25519: "ABC"])
    end

    test "to_xdr/1", %{account_id: account_id, ed25519_key: ed25519_key, xdr: xdr} do
      ^xdr =
        [signer: [account_id: account_id, ed25519: ed25519_key]]
        |> RevokeSponsorship.new()
        |> RevokeSponsorship.to_xdr()
    end
  end
end
