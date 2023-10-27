defmodule Stellar.TxBuild.ExtendFootprintTTLTest do
  use ExUnit.Case

  alias Stellar.TxBuild.ExtendFootprintTTL

  setup do
    extend_to = 100

    %{
      extend_to: extend_to
    }
  end

  test "new/1", %{extend_to: extend_to} do
    %ExtendFootprintTTL{extend_to: ^extend_to} = ExtendFootprintTTL.new(extend_to: extend_to)
  end

  test "new/1 with invalid extend_to" do
    {:error, :invalid_operation_attributes} = ExtendFootprintTTL.new("ABC")
  end

  test "to_xdr/1", %{extend_to: extend_to} do
    %StellarBase.XDR.OperationBody{
      value: %StellarBase.XDR.Operations.ExtendFootprintTTL{
        ext: %StellarBase.XDR.ExtensionPoint{
          extension_point: %StellarBase.XDR.Void{value: nil},
          type: 0
        },
        extend_to: %StellarBase.XDR.UInt32{datum: 100}
      },
      type: %StellarBase.XDR.OperationType{identifier: :EXTEND_FOOTPRINT_TTL}
    } =
      extend_to
      |> (&ExtendFootprintTTL.new(extend_to: &1)).()
      |> ExtendFootprintTTL.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = ExtendFootprintTTL.to_xdr(%{})
  end
end
