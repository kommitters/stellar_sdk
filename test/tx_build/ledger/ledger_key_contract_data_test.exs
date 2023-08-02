defmodule Stellar.TxBuild.Ledger.LedgerKeyContractDataTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCAddress
  alias Stellar.TxBuild.Ledger.LedgerKeyContractData

  setup do
    contract = SCAddress.new("CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN")
    key = %Stellar.TxBuild.SCVal{type: :ledger_key_contract_instance}
    durability_temporary = :temporary
    durability_persistent = :persistent
    body_type_data_entry = :data_entry
    body_type_expiration_ext = :expiration_ext

    %{
      contract: contract,
      key: key,
      durability_temporary: durability_temporary,
      durability_persistent: durability_persistent,
      body_type_data_entry: body_type_data_entry,
      body_type_expiration_ext: body_type_expiration_ext
    }
  end

  test "new/1 data_entry", %{
    contract: contract,
    key: key,
    durability_temporary: durability,
    body_type_data_entry: body_type
  } do
    %LedgerKeyContractData{
      contract: ^contract,
      key: ^key,
      durability: ^durability,
      body_type: ^body_type
    } =
      LedgerKeyContractData.new(
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      )
  end

  test "new/1 expiration_ext", %{
    contract: contract,
    key: key,
    durability_persistent: durability,
    body_type_expiration_ext: body_type
  } do
    %LedgerKeyContractData{
      contract: ^contract,
      key: ^key,
      durability: ^durability,
      body_type: ^body_type
    } =
      LedgerKeyContractData.new(
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_ledger_key_args} =
      LedgerKeyContractData.new(
        contract: "ABC",
        key: "ABC",
        durability: "invalid_durability",
        body_type: "invalid_body_type"
      )
  end

  test "new/1 with invalid key", %{
    contract: contract,
    durability_persistent: durability,
    body_type_expiration_ext: body_type
  } do
    {:error, :invalid_key} =
      LedgerKeyContractData.new(
        contract: contract,
        key: "invalid_key",
        durability: durability,
        body_type: body_type
      )
  end

  test "to_xdr/1 data_entry", %{
    contract: contract,
    key: key,
    durability_temporary: durability,
    body_type_data_entry: body_type
  } do
    %StellarBase.XDR.LedgerKeyContractData{
      contract: %StellarBase.XDR.SCAddress{
        sc_address: %StellarBase.XDR.Hash{
          value:
            <<136, 199, 21, 221, 153, 62, 83, 56, 9, 112, 55, 17, 157, 226, 244, 109, 177, 22,
              241, 170, 12, 226, 193, 229, 39, 50, 103, 40, 26, 129, 1, 237>>
        },
        type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_CONTRACT}
      },
      key: %StellarBase.XDR.SCVal{
        value: %StellarBase.XDR.Void{value: nil},
        type: %StellarBase.XDR.SCValType{identifier: :SCV_LEDGER_KEY_CONTRACT_INSTANCE}
      },
      durability: %StellarBase.XDR.ContractDataDurability{identifier: :TEMPORARY},
      body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :DATA_ENTRY}
    } =
      LedgerKeyContractData.new(
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      )
      |> LedgerKeyContractData.to_xdr()
  end

  test "to_xdr/1 expiration_ext", %{
    contract: contract,
    key: key,
    durability_persistent: durability,
    body_type_expiration_ext: body_type
  } do
    %StellarBase.XDR.LedgerKeyContractData{
      contract: %StellarBase.XDR.SCAddress{
        sc_address: %StellarBase.XDR.Hash{
          value:
            <<136, 199, 21, 221, 153, 62, 83, 56, 9, 112, 55, 17, 157, 226, 244, 109, 177, 22,
              241, 170, 12, 226, 193, 229, 39, 50, 103, 40, 26, 129, 1, 237>>
        },
        type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_CONTRACT}
      },
      key: %StellarBase.XDR.SCVal{
        value: %StellarBase.XDR.Void{value: nil},
        type: %StellarBase.XDR.SCValType{identifier: :SCV_LEDGER_KEY_CONTRACT_INSTANCE}
      },
      durability: %StellarBase.XDR.ContractDataDurability{identifier: :PERSISTENT},
      body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :EXPIRATION_EXTENSION}
    } =
      LedgerKeyContractData.new(
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      )
      |> LedgerKeyContractData.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = LedgerKeyContractData.to_xdr(%{})
  end
end
