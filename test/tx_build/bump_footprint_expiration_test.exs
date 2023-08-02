defmodule Stellar.TxBuild.BumpFootprintExpirationTest do
  use ExUnit.Case

  alias Stellar.TxBuild.BumpFootprintExpiration

  setup do
    ledgers_to_expire = 100

    %{
      ledgers_to_expire: ledgers_to_expire
    }
  end

  test "new/1", %{ledgers_to_expire: ledgers_to_expire} do
    %BumpFootprintExpiration{ledgers_to_expire: ^ledgers_to_expire} =
      BumpFootprintExpiration.new(ledgers_to_expire: ledgers_to_expire)
  end

  test "new/1 with invalid ledgers_to_expire" do
    {:error, :invalid_bump_footprint_op} = BumpFootprintExpiration.new("ABC")
  end

  test "to_xdr/1", %{ledgers_to_expire: ledgers_to_expire} do
    %StellarBase.XDR.OperationBody{
      value: %StellarBase.XDR.Operations.BumpFootprintExpiration{
        ext: %StellarBase.XDR.ExtensionPoint{
          extension_point: %StellarBase.XDR.Void{value: nil},
          type: 0
        },
        ledgers_to_expire: %StellarBase.XDR.UInt32{datum: 100}
      },
      type: %StellarBase.XDR.OperationType{identifier: :BUMP_FOOTPRINT_EXPIRATION}
    } =
      ledgers_to_expire
      |> (&BumpFootprintExpiration.new(ledgers_to_expire: &1)).()
      |> BumpFootprintExpiration.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = BumpFootprintExpiration.to_xdr(%{})
  end
end
