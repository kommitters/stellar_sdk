defmodule Stellar.TxBuild.SCObjectTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{SCAddress, SCVal, SCMapEntry, SCObject}

  setup do
    # vec
    sc_val = SCVal.new(i32: 123)
    sc_vec = [sc_val, sc_val]

    # map
    sc_map_entry = SCMapEntry.new(sc_val, sc_val)
    sc_map = [sc_map_entry, sc_map_entry]

    # address
    public_key = "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
    address = SCAddress.new(account: public_key)

    # nonce_key
    hash = "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"
    nonce_key = SCAddress.new(contract: hash)

    discriminants = [
      %{
        type: :vec,
        value: sc_vec,
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.SCVec{
            sc_vals: [
              %StellarBase.XDR.SCVal{
                value: %StellarBase.XDR.Int32{datum: 123},
                type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
              },
              %StellarBase.XDR.SCVal{
                value: %StellarBase.XDR.Int32{datum: 123},
                type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
              }
            ]
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_VEC}
        }
      },
      %{
        type: :map,
        value: sc_map,
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.SCMap{
            scmap_entries: [
              %StellarBase.XDR.SCMapEntry{
                key: %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.Int32{datum: 123},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
                },
                val: %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.Int32{datum: 123},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
                }
              },
              %StellarBase.XDR.SCMapEntry{
                key: %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.Int32{datum: 123},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
                },
                val: %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.Int32{datum: 123},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
                }
              }
            ]
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_MAP}
        }
      },
      %{
        type: :u64,
        value: 23,
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.UInt64{datum: 23},
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_U64}
        }
      },
      %{
        type: :i64,
        value: -5,
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.Int64{datum: -5},
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_I64}
        }
      },
      %{
        type: :u128,
        value: %{lo: 5, hi: 6},
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.Int128Parts{
            lo: %StellarBase.XDR.UInt64{datum: 5},
            hi: %StellarBase.XDR.UInt64{datum: 6}
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_U128}
        }
      },
      %{
        type: :i128,
        value: %{lo: 3, hi: 4},
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.Int128Parts{
            lo: %StellarBase.XDR.UInt64{datum: 3},
            hi: %StellarBase.XDR.UInt64{datum: 4}
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_I128}
        }
      },
      %{
        type: :bytes,
        value: "GCIZ3GSM5",
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.VariableOpaque256000{opaque: "GCIZ3GSM5"},
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_BYTES}
        }
      },
      %{
        type: :contract_code,
        value: {:wasm_ref, hash},
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.SCContractCode{
            contract_code: %StellarBase.XDR.Hash{
              value: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"
            },
            type: %StellarBase.XDR.SCContractCodeType{
              identifier: :SCCONTRACT_CODE_WASM_REF
            }
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_CONTRACT_CODE}
        }
      },
      %{
        type: :address,
        value: address,
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.SCAddress{
            sc_address: %StellarBase.XDR.AccountID{
              account_id: %StellarBase.XDR.PublicKey{
                public_key: %StellarBase.XDR.UInt256{
                  datum:
                    <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87,
                      6, 25, 27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
                },
                type: %StellarBase.XDR.PublicKeyType{
                  identifier: :PUBLIC_KEY_TYPE_ED25519
                }
              }
            },
            type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_ADDRESS}
        }
      },
      %{
        type: :nonce_key,
        value: nonce_key,
        to_xdr: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.SCAddress{
            sc_address: %StellarBase.XDR.Hash{value: "GCIZ3GSM5XL7OUS4UP64THMDZ7CZ3ZWN"},
            type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_contract}
          },
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_NONCE_KEY}
        }
      }
    ]

    %{discriminants: discriminants}
  end

  test "new/1", %{discriminants: discriminants} do
    for %{type: type, value: value} <- discriminants do
      %SCObject{type: ^type, value: ^value} = SCObject.new([{type, value}])
    end
  end

  test "to_xdr/1", %{discriminants: discriminants} do
    for %{type: type, value: value, to_xdr: to_xdr} <- discriminants do
      expect = [{type, value}] |> SCObject.new() |> SCObject.to_xdr()
      ^to_xdr = expect
    end
  end
end
