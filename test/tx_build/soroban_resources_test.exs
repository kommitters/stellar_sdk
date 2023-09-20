defmodule Stellar.TxBuild.SorobanResourcesTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{LedgerFootprint, LedgerKey}

  alias Stellar.TxBuild.SorobanResources

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

    %{
      footprint: footprint,
      instructions: instructions,
      read_bytes: read_bytes,
      write_bytes: write_bytes
    }
  end

  test "new/1", %{
    footprint: footprint,
    instructions: instructions,
    read_bytes: read_bytes,
    write_bytes: write_bytes
  } do
    %SorobanResources{
      footprint: ^footprint,
      instructions: ^instructions,
      read_bytes: ^read_bytes,
      write_bytes: ^write_bytes
    } =
      SorobanResources.new(
        footprint: footprint,
        instructions: instructions,
        read_bytes: read_bytes,
        write_bytes: write_bytes
      )
  end

  test "new/1 with invalid instructions", %{
    footprint: footprint,
    read_bytes: read_bytes,
    write_bytes: write_bytes
  } do
    {:error, :invalid_soroban_resources_args} =
      SorobanResources.new(
        footprint: footprint,
        instructions: "invalid_instructions",
        read_bytes: read_bytes,
        write_bytes: write_bytes
      )
  end

  test "new/1 with invalid footprint", %{
    instructions: instructions,
    read_bytes: read_bytes,
    write_bytes: write_bytes
  } do
    {:error, :invalid_footprint} =
      SorobanResources.new(
        footprint: "invalid",
        instructions: instructions,
        read_bytes: read_bytes,
        write_bytes: write_bytes
      )
  end

  test "to_xdr/1", %{
    footprint: footprint,
    instructions: instructions,
    read_bytes: read_bytes,
    write_bytes: write_bytes
  } do
    %StellarBase.XDR.SorobanResources{
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
    } =
      SorobanResources.new(
        footprint: footprint,
        instructions: instructions,
        read_bytes: read_bytes,
        write_bytes: write_bytes
      )
      |> SorobanResources.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = SorobanResources.to_xdr(%{})
  end
end
