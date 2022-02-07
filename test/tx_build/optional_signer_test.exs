defmodule Stellar.TxBuild.OptionalSignerTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [signer_xdr: 1]

  alias Stellar.TxBuild.{Signer, OptionalSigner}
  alias StellarBase.XDR.OptionalSigner, as: OptionalSignerXDR

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      signer: Signer.new(ed25519: account_id, weight: 2),
      signer_xdr: signer_xdr(ed25519: account_id, weight: 2)
    }
  end

  test "new/2", %{signer: signer} do
    %OptionalSigner{signer: ^signer} = OptionalSigner.new(signer)
  end

  test "new/2 without_flags" do
    %OptionalSigner{signer: nil} = OptionalSigner.new()
  end

  test "to_xdr/1", %{signer_xdr: signer_xdr, signer: signer} do
    %OptionalSignerXDR{signer: ^signer_xdr} =
      signer
      |> OptionalSigner.new()
      |> OptionalSigner.to_xdr()
  end

  test "to_xdr/1 without_flags" do
    %OptionalSignerXDR{signer: nil} =
      nil
      |> OptionalSigner.new()
      |> OptionalSigner.to_xdr()
  end
end
