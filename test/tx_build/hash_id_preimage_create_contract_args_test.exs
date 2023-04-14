defmodule Stellar.TxBuild.HashIDPreimageCreateContractArgsTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [hash_id_preimage_create_contract_args_xdr: 4]

  alias Stellar.TxBuild.HashIDPreimageCreateContractArgs, as: TxHashIDPreimageCreateContractArgs
  alias Stellar.TxBuild.SCContractCode, as: TxSCContractCode

  setup do
    network_id = "network_id"
    source = "sc_contract_code"
    source_type = :SCCONTRACT_CODE_WASM_REF
    salt = 123

    xdr = hash_id_preimage_create_contract_args_xdr(network_id, source, source_type, salt)

    %{
      network_id: network_id,
      source: TxSCContractCode.new(wasm_ref: "sc_contract_code"),
      salt: salt,
      xdr: xdr
    }
  end

  test "new/1", %{network_id: network_id, source: source, salt: salt} do
    %TxHashIDPreimageCreateContractArgs{
      network_id: ^network_id,
      source: ^source,
      salt: ^salt
    } = TxHashIDPreimageCreateContractArgs.new(network_id: network_id, source: source, salt: salt)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_hash_id_preimage_contract_args} =
      TxHashIDPreimageCreateContractArgs.new("invalid_args")
  end

  test "new/1 with invalid source", %{network_id: network_id, salt: salt} do
    {:error, :invalid_source} =
      TxHashIDPreimageCreateContractArgs.new(
        network_id: network_id,
        source: "invalid_value",
        salt: salt
      )
  end

  test "to_xdr/1", %{network_id: network_id, source: source, salt: salt, xdr: xdr} do
    ^xdr =
      [network_id: network_id, source: source, salt: salt]
      |> TxHashIDPreimageCreateContractArgs.new()
      |> TxHashIDPreimageCreateContractArgs.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_hash_id_preimage_contract_args} =
      TxHashIDPreimageCreateContractArgs.to_xdr("invalid_struct")
  end
end
