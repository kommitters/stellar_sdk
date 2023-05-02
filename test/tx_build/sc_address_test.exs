defmodule Stellar.TxBuild.SCAddressTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCAddress, as: TxSCAddress

  alias StellarBase.XDR.{
    Hash,
    SCAddressType,
    AccountID,
    UInt256,
    PublicKeyType,
    SCAddress,
    PublicKey
  }

  setup do
    public_key = "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
    contract = "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN"

    %{
      public_key: public_key,
      contract: contract
    }
  end

  test "new/1 when type is account", %{public_key: public_key} do
    %TxSCAddress{type: :account, value: ^public_key} = TxSCAddress.new(public_key)
  end

  test "new/1 when type is contract", %{contract: contract} do
    %TxSCAddress{type: :contract, value: ^contract} = TxSCAddress.new(contract)
  end

  test "new/1 when data is incorrect" do
    {:error, :invalid_sc_address} = TxSCAddress.new("CCEMOFO5TE7FGOAJOA3RDH")
  end

  test "to_xdr when type is account", %{public_key: public_key} do
    %SCAddress{
      sc_address: %AccountID{
        account_id: %PublicKey{
          public_key: %UInt256{
            datum:
              <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87, 6, 25,
                27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
          },
          type: %PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      type: %SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
    } = public_key |> TxSCAddress.new() |> TxSCAddress.to_xdr()
  end

  test "to_xdr when type is contract", %{contract: contract} do
    %SCAddress{
      sc_address: %Hash{value: "CCEMOFO5TE7FGOAJOA3RDHPC6RW3CFXRVIGOFQPFE4ZGOKA2QEA636SN"},
      type: %SCAddressType{identifier: :SC_ADDRESS_contract}
    } = contract |> TxSCAddress.new() |> TxSCAddress.to_xdr()
  end
end
