defmodule Stellar.TxBuild.Ledger.ContractDataTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCAddress
  alias Stellar.TxBuild.Ledger.ContractData

  setup do
    contract = SCAddress.new("CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN")
    key = %Stellar.TxBuild.SCVal{type: :ledger_key_contract_instance}
    durability_temporary = :temporary
    durability_persistent = :persistent

    %{
      contract: contract,
      key: key,
      durability_temporary: durability_temporary,
      durability_persistent: durability_persistent
    }
  end

  test "new/1 data_entry", %{
    contract: contract,
    key: key,
    durability_temporary: durability
  } do
    %ContractData{
      contract: ^contract,
      key: ^key,
      durability: ^durability
    } =
      ContractData.new(
        contract: contract,
        key: key,
        durability: durability
      )
  end

  test "new/1 expiration_ext", %{
    contract: contract,
    key: key,
    durability_persistent: durability
  } do
    %ContractData{
      contract: ^contract,
      key: ^key,
      durability: ^durability
    } =
      ContractData.new(
        contract: contract,
        key: key,
        durability: durability
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_ledger_key_args} =
      ContractData.new(
        contract: "ABC",
        key: "ABC",
        durability: "invalid_durability",
        body_type: "invalid_body_type"
      )
  end

  test "new/1 with invalid key", %{
    contract: contract,
    durability_persistent: durability
  } do
    {:error, :invalid_key} =
      ContractData.new(
        contract: contract,
        key: "invalid_key",
        durability: durability
      )
  end

  test "to_xdr/1 data_entry", %{
    contract: contract,
    key: key,
    durability_temporary: durability
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
      durability: %StellarBase.XDR.ContractDataDurability{identifier: :TEMPORARY}
    } =
      ContractData.new(
        contract: contract,
        key: key,
        durability: durability
      )
      |> ContractData.to_xdr()
  end

  test "to_xdr/1 expiration_ext", %{
    contract: contract,
    key: key,
    durability_persistent: durability
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
      durability: %StellarBase.XDR.ContractDataDurability{identifier: :PERSISTENT}
    } =
      ContractData.new(
        contract: contract,
        key: key,
        durability: durability
      )
      |> ContractData.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = ContractData.to_xdr(%{})
  end
end
