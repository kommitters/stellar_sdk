defmodule Stellar.TxBuild.LedgerFootprintTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{LedgerFootprint, LedgerKey}
  alias StellarBase.XDR.LedgerFootprint, as: LedgerFootprintXDR

  setup do
    hash = "ABC123"
    body_type = :data_entry

    contract_code_args = [hash: hash, body_type: body_type]
    read_only = [LedgerKey.new({:contract_code, contract_code_args})]

    read_write = [
      LedgerKey.new({:contract_code, contract_code_args}),
      LedgerKey.new({:contract_code, contract_code_args})
    ]

    ledger_footprint = LedgerFootprint.new(read_only: read_only, read_write: read_write)

    xdr = %LedgerFootprintXDR{
      read_only: %StellarBase.XDR.LedgerKeyList{
        ledger_keys: [
          %StellarBase.XDR.LedgerKey{
            entry: %StellarBase.XDR.LedgerKeyContractCode{
              hash: %StellarBase.XDR.Hash{value: "ABC123"},
              body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :DATA_ENTRY}
            },
            type: %StellarBase.XDR.LedgerEntryType{identifier: :CONTRACT_CODE}
          }
        ]
      },
      read_write: %StellarBase.XDR.LedgerKeyList{
        ledger_keys: [
          %StellarBase.XDR.LedgerKey{
            entry: %StellarBase.XDR.LedgerKeyContractCode{
              hash: %StellarBase.XDR.Hash{value: "ABC123"},
              body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :DATA_ENTRY}
            },
            type: %StellarBase.XDR.LedgerEntryType{identifier: :CONTRACT_CODE}
          },
          %StellarBase.XDR.LedgerKey{
            entry: %StellarBase.XDR.LedgerKeyContractCode{
              hash: %StellarBase.XDR.Hash{value: "ABC123"},
              body_type: %StellarBase.XDR.ContractEntryBodyType{identifier: :DATA_ENTRY}
            },
            type: %StellarBase.XDR.LedgerEntryType{identifier: :CONTRACT_CODE}
          }
        ]
      }
    }

    %{
      read_only: read_only,
      read_write: read_write,
      ledger_footprint: ledger_footprint,
      xdr: xdr
    }
  end

  test "new/2", %{read_only: read_only, read_write: read_write} do
    %LedgerFootprint{read_only: ^read_only, read_write: ^read_write} =
      LedgerFootprint.new(read_only: read_only, read_write: read_write)
  end

  test "new/2 with default values" do
    %LedgerFootprint{read_only: [], read_write: []} = LedgerFootprint.new()
  end

  test "new/2 list with invalid_ledger_keys" do
    {:error, :invalid_ledger_keys} = LedgerFootprint.new(read_only: [:invalid])
  end

  test "new/2 with invalid_ledger_keys" do
    {:error, :invalid_ledger_keys} = LedgerFootprint.new(read_only: :invalid)
  end

  test "new/2 with invalid arguments" do
    {:error, :invalid_ledger_footprint} = LedgerFootprint.new(:invalid)
  end

  test "to_xdr/1", %{ledger_footprint: ledger_footprint, xdr: xdr} do
    ^xdr = LedgerFootprint.to_xdr(ledger_footprint)
  end

  test "to_xdr/1 invalid struct" do
    {:error, :invalid_struct} = LedgerFootprint.to_xdr(:invalid)
  end
end
