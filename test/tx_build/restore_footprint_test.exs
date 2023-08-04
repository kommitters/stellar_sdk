defmodule Stellar.TxBuild.RestoreFootprintTest do
  use ExUnit.Case

  alias Stellar.TxBuild.RestoreFootprint

  test "new/2" do
    %RestoreFootprint{value: nil} = RestoreFootprint.new()
  end

  test "to_xdr/1" do
    restore_footprint = RestoreFootprint.new()

    %StellarBase.XDR.OperationBody{
      value: %StellarBase.XDR.Operations.RestoreFootprint{
        ext: %StellarBase.XDR.ExtensionPoint{
          extension_point: %StellarBase.XDR.Void{value: nil},
          type: 0
        }
      },
      type: %StellarBase.XDR.OperationType{identifier: :RESTORE_FOOTPRINT}
    } = RestoreFootprint.to_xdr(restore_footprint)
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = RestoreFootprint.to_xdr(:invalid)
  end
end
