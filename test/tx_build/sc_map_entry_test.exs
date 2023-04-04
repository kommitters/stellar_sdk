defmodule Stellar.TxBuild.SCMapEntryTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{SCMapEntry, SCVal, SCObject, SCAddress}

  setup do
    public_key = "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
    address = SCAddress.new(account: public_key)
    obj = SCObject.new(address: address)
    key = SCVal.new(i32: 21)
    val = SCVal.new(object: obj)

    %{
      key: key,
      val: val,
      to_xdr: %StellarBase.XDR.SCMapEntry{
        key: %StellarBase.XDR.SCVal{
          value: %StellarBase.XDR.Int32{datum: 21},
          type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
        },
        val: %StellarBase.XDR.SCVal{
          value: %StellarBase.XDR.OptionalSCObject{
            sc_object: %StellarBase.XDR.SCObject{
              sc_object: %StellarBase.XDR.SCAddress{
                sc_address: %StellarBase.XDR.AccountID{
                  account_id: %StellarBase.XDR.PublicKey{
                    public_key: %StellarBase.XDR.UInt256{
                      datum:
                        <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112,
                          87, 6, 25, 27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
                    },
                    type: %StellarBase.XDR.PublicKeyType{
                      identifier: :PUBLIC_KEY_TYPE_ED25519
                    }
                  }
                },
                type: %StellarBase.XDR.SCAddressType{
                  identifier: :SC_ADDRESS_TYPE_ACCOUNT
                }
              },
              type: %StellarBase.XDR.SCObjectType{identifier: :SCO_ADDRESS}
            }
          },
          type: %StellarBase.XDR.SCValType{identifier: :SCV_OBJECT}
        }
      }
    }
  end

  test "new/1", %{key: key, val: val} do
    %SCMapEntry{key: ^key, val: ^val} = SCMapEntry.new(key, val)
  end

  test "new/1 when key is incorrect", %{val: val} do
    {:error, :invalid_sc_map_entry} = SCMapEntry.new("", val)
  end

  test "new/1 when val is incorrect", %{key: key} do
    {:error, :invalid_sc_map_entry} = SCMapEntry.new(key, "")
  end

  test "to_xdr/1", %{key: key, val: val, to_xdr: to_xdr} do
    ^to_xdr =
      key
      |> SCMapEntry.new(val)
      |> SCMapEntry.to_xdr()
  end
end
