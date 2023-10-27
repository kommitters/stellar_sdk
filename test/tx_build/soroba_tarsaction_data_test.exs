defmodule Stellar.TxBuild.SorobanTransactionDataTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{LedgerFootprint, LedgerKey}
  alias Stellar.TxBuild.{SorobanResources, SorobanTransactionData}

  setup do
    hash = "ABC123"

    contract_code_args = [hash: hash]
    read_only = [LedgerKey.new({:contract_code, contract_code_args})]

    read_write = [
      LedgerKey.new({:contract_code, contract_code_args}),
      LedgerKey.new({:contract_code, contract_code_args})
    ]

    footprint = LedgerFootprint.new(read_only: read_only, read_write: read_write)
    instructions = 1000
    read_bytes = 1024
    write_bytes = 512

    resources =
      SorobanResources.new(
        footprint: footprint,
        instructions: instructions,
        read_bytes: read_bytes,
        write_bytes: write_bytes
      )

    resource_fee = 100

    soroban_transaction_data =
      SorobanTransactionData.new(resources: resources, resource_fee: resource_fee)

    xdr = %StellarBase.XDR.SorobanTransactionData{
      ext: %StellarBase.XDR.ExtensionPoint{
        extension_point: %StellarBase.XDR.Void{value: nil},
        type: 0
      },
      resources: %StellarBase.XDR.SorobanResources{
        footprint: %StellarBase.XDR.LedgerFootprint{
          read_only: %StellarBase.XDR.LedgerKeyList{
            ledger_keys: [
              %StellarBase.XDR.LedgerKey{
                entry: %StellarBase.XDR.LedgerKeyContractCode{
                  hash: %StellarBase.XDR.Hash{value: "ABC123"}
                },
                type: %StellarBase.XDR.LedgerEntryType{identifier: :CONTRACT_CODE}
              }
            ]
          },
          read_write: %StellarBase.XDR.LedgerKeyList{
            ledger_keys: [
              %StellarBase.XDR.LedgerKey{
                entry: %StellarBase.XDR.LedgerKeyContractCode{
                  hash: %StellarBase.XDR.Hash{value: "ABC123"}
                },
                type: %StellarBase.XDR.LedgerEntryType{identifier: :CONTRACT_CODE}
              },
              %StellarBase.XDR.LedgerKey{
                entry: %StellarBase.XDR.LedgerKeyContractCode{
                  hash: %StellarBase.XDR.Hash{value: "ABC123"}
                },
                type: %StellarBase.XDR.LedgerEntryType{identifier: :CONTRACT_CODE}
              }
            ]
          }
        },
        instructions: %StellarBase.XDR.UInt32{datum: 1000},
        read_bytes: %StellarBase.XDR.UInt32{datum: 1024},
        write_bytes: %StellarBase.XDR.UInt32{datum: 512}
      },
      resource_fee: %StellarBase.XDR.Int64{datum: 100}
    }

    %{
      resources: resources,
      resource_fee: resource_fee,
      soroban_transaction_data: soroban_transaction_data,
      xdr: xdr
    }
  end

  test "new/1", %{resources: resources, resource_fee: resource_fee} do
    %SorobanTransactionData{resources: ^resources, resource_fee: ^resource_fee} =
      SorobanTransactionData.new(resources: resources, resource_fee: resource_fee)
  end

  test "new/1 with invalid soroban transaction args" do
    {:error, :invalid_soroban_transaction_data} = SorobanTransactionData.new(:invalid)
  end

  test "new/1 with invalid resources", %{resource_fee: resource_fee} do
    {:error, :invalid_resources} =
      SorobanTransactionData.new(resources: :invalid, resource_fee: resource_fee)
  end

  test "to_xdr/1", %{soroban_transaction_data: soroban_transaction_data, xdr: xdr} do
    ^xdr = SorobanTransactionData.to_xdr(soroban_transaction_data)
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = SorobanTransactionData.to_xdr(%{})
  end
end
