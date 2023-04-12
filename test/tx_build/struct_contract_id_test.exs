defmodule Stellar.TxBuild.StructContractIDTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [struct_contract_id_xdr: 3]

  alias Stellar.TxBuild.StructContractID, as: TxStructContractID

  setup do
    network_id = "network_id"
    contract_id = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
    salt = 123
    xdr = struct_contract_id_xdr(network_id, contract_id, salt)

    %{network_id: "network_id", contract_id: contract_id, salt: 123, xdr: xdr}
  end

  test "new/1", %{network_id: network_id, contract_id: contract_id, salt: salt} do
    %TxStructContractID{
      network_id: ^network_id,
      contract_id: ^contract_id,
      salt: ^salt
    } = TxStructContractID.new(network_id: network_id, contract_id: contract_id, salt: salt)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_struct_contract_id} = TxStructContractID.new("invalid_args")
  end

  test "to_xdr/1", %{network_id: network_id, contract_id: contract_id, salt: salt, xdr: xdr} do
    ^xdr =
      TxStructContractID.new(network_id: network_id, contract_id: contract_id, salt: salt)
      |> TxStructContractID.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_contract_id} = TxStructContractID.to_xdr("invalid_struct")
  end
end
