defmodule Stellar.TxBuild.Ed25519ContractIDTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [ed25519_contract_id_xdr: 3]

  alias Stellar.TxBuild.Ed25519ContractID, as: TxEd25519ContractID

  setup do
    network_id = "network_id"
    ed25519 = 123
    salt = 123
    xdr = ed25519_contract_id_xdr(network_id, ed25519, salt)

    %{
      network_id: network_id,
      ed25519: ed25519,
      salt: salt,
      xdr: xdr
    }
  end

  test "new/1", %{
    network_id: network_id,
    ed25519: ed25519,
    salt: salt
  } do
    %TxEd25519ContractID{
      network_id: ^network_id,
      ed25519: ^ed25519,
      salt: ^salt
    } = TxEd25519ContractID.new(network_id: network_id, ed25519: ed25519, salt: salt)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_ed25519_contract_id} = TxEd25519ContractID.new("invalid_args")
  end

  test "to_xdr/1", %{
    network_id: network_id,
    ed25519: ed25519,
    salt: salt,
    xdr: xdr
  } do
    ^xdr =
      TxEd25519ContractID.new(network_id: network_id, ed25519: ed25519, salt: salt)
      |> TxEd25519ContractID.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_ed25519_contract_id} = TxEd25519ContractID.to_xdr("invalid_struct")
  end
end
