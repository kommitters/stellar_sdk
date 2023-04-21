defmodule Stellar.TxBuild.SCValTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCAddress,
    SCStatus,
    SCVal,
    SCMapEntry
  }

  setup do
    # SCVal
    sc_val = SCVal.new(i32: 123)

    # SCMapEntry
    sc_val_key = SCVal.new(symbol: "sc_val_key")
    sc_val_val = SCVal.new(i32: 123)
    sc_map_entry = SCMapEntry.new(sc_val_key, sc_val_val)

    # SCAddress
    public_key = "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A"
    sc_address = SCAddress.new(account: public_key)

    sc_address_xdr = %StellarBase.XDR.SCAddress{
      sc_address: %StellarBase.XDR.AccountID{
        account_id: %StellarBase.XDR.PublicKey{
          public_key: %StellarBase.XDR.UInt256{
            datum:
              <<124, 84, 92, 174, 34, 185, 234, 132, 96, 55, 105, 43, 197, 74, 26, 112, 87, 6, 25,
                27, 0, 247, 99, 30, 96, 184, 166, 70, 114, 125, 104, 125>>
          },
          type: %StellarBase.XDR.PublicKeyType{identifier: :PUBLIC_KEY_TYPE_ED25519}
        }
      },
      type: %StellarBase.XDR.SCAddressType{identifier: :SC_ADDRESS_TYPE_ACCOUNT}
    }

    discriminants = [
      %{type: :bool, value: true},
      %{type: :void, value: nil},
      %{type: :u32, value: 12345},
      %{type: :i32, value: -12345},
      %{type: :u64, value: 67890},
      %{type: :i64, value: -67890},
      %{type: :time_point, value: 12345},
      %{type: :duration, value: 67890},
      %{type: :u128, value: %{lo: -12345, hi: 12345}},
      %{type: :i128, value: %{lo: -67890, hi: 67890}},
      %{type: :u256, value: "u256"},
      %{type: :i256, value: "i256"},
      %{type: :bytes, value: "bytes"},
      %{type: :string, value: "string"},
      %{type: :symbol, value: "symbol"},
      %{type: :vec, value: [sc_val]},
      %{type: :map, value: [sc_map_entry]},
      %{type: :contract, value: :token},
      %{type: :contract, value: {:wasm_ref, "hash"}},
      %{type: :address, value: sc_address},
      %{type: :ledger_key_contract, value: nil},
      %{type: :ledger_key_nonce, value: sc_address}
    ]

    invalid_discriminants = [
      %{type: :bool, value: "true"},
      %{type: :u32, value: "12345"},
      %{type: :i32, value: "-12345"},
      %{type: :u64, value: "67890"},
      %{type: :i64, value: "-67890"},
      %{type: :time_point, value: "12345"},
      %{type: :duration, value: "67890"},
      %{type: :u128, value: %{lo: "-12345", hi: "12345"}},
      %{type: :i128, value: %{lo: "-67890", hi: "67890"}},
      %{type: :u256, value: 256},
      %{type: :i256, value: 256},
      %{type: :bytes, value: :bytes},
      %{type: :string, value: :string},
      %{type: :symbol, value: :symbol},
      %{type: :vec, value: [:sc_val]},
      %{type: :map, value: [:sc_map_entry]},
      %{type: :contract, value: :invalid},
      %{type: :contract, value: {:wasm_ref, :invalid}},
      %{type: :address, value: :invalid},
      %{type: :ledger_key_nonce, value: :invalid}
    ]

    sc_status_discriminants = [
      %{sc_status: SCStatus.new(ok: nil)},
      %{sc_status: SCStatus.new(unknown_error: :UNKNOWN_ERROR_GENERAL)},
      %{sc_status: SCStatus.new(host_value_error: :HOST_VALUE_UNKNOWN_ERROR)},
      %{sc_status: SCStatus.new(host_object_error: :HOST_OBJECT_UNKNOWN_ERROR)},
      %{sc_status: SCStatus.new(host_function_error: :HOST_FN_UNKNOWN_ERROR)},
      %{sc_status: SCStatus.new(host_storage_error: :HOST_STORAGE_UNKNOWN_ERROR)},
      %{sc_status: SCStatus.new(vm_error: :VM_UNKNOWN)},
      %{sc_status: SCStatus.new(contract_error: 4_294_967_295)},
      %{sc_status: SCStatus.new(host_auth_error: :HOST_AUTH_UNKNOWN_ERROR)}
    ]

    xdr_discriminants = [
      %{
        val_type: :SCV_BOOL,
        module: %StellarBase.XDR.Bool{value: true},
        type: :bool,
        value: true
      },
      %{val_type: :SCV_VOID, module: %StellarBase.XDR.Void{value: nil}, type: :void, value: nil},
      %{
        val_type: :SCV_STATUS,
        module: %StellarBase.XDR.SCStatus{
          code: %StellarBase.XDR.SCUnknownErrorCode{
            identifier: :UNKNOWN_ERROR_GENERAL
          },
          type: %StellarBase.XDR.SCStatusType{identifier: :SST_UNKNOWN_ERROR}
        },
        type: :status,
        value: SCStatus.new(unknown_error: :UNKNOWN_ERROR_GENERAL)
      },
      %{val_type: :SCV_U32, module: %StellarBase.XDR.UInt32{datum: 123}, type: :u32, value: 123},
      %{val_type: :SCV_I32, module: %StellarBase.XDR.Int32{datum: 123}, type: :i32, value: 123},
      %{val_type: :SCV_U64, module: %StellarBase.XDR.UInt64{datum: 123}, type: :u64, value: 123},
      %{val_type: :SCV_I64, module: %StellarBase.XDR.Int64{datum: 123}, type: :i64, value: 123},
      %{
        val_type: :SCV_TIMEPOINT,
        module: %StellarBase.XDR.TimePoint{value: 123},
        type: :time_point,
        value: 123
      },
      %{
        val_type: :SCV_DURATION,
        module: %StellarBase.XDR.Duration{value: 123},
        type: :duration,
        value: 123
      },
      %{
        val_type: :SCV_U128,
        module: %StellarBase.XDR.Int128Parts{
          lo: %StellarBase.XDR.UInt64{datum: 123},
          hi: %StellarBase.XDR.UInt64{datum: 123}
        },
        type: :u128,
        value: %{lo: 123, hi: 123}
      },
      %{
        val_type: :SCV_I128,
        module: %StellarBase.XDR.Int128Parts{
          lo: %StellarBase.XDR.UInt64{datum: 123},
          hi: %StellarBase.XDR.UInt64{datum: 123}
        },
        type: :i128,
        value: %{lo: 123, hi: 123}
      },
      %{
        val_type: :SCV_U256,
        module: %StellarBase.XDR.UInt256{datum: "Hello"},
        type: :u256,
        value: "Hello"
      },
      %{
        val_type: :SCV_I256,
        module: %StellarBase.XDR.UInt256{datum: "Hello"},
        type: :i256,
        value: "Hello"
      },
      %{
        val_type: :SCV_BYTES,
        module: %StellarBase.XDR.SCBytes{value: "Hello"},
        type: :bytes,
        value: "Hello"
      },
      %{
        val_type: :SCV_STRING,
        module: %StellarBase.XDR.SCString{value: "Hello"},
        type: :string,
        value: "Hello"
      },
      %{
        val_type: :SCV_SYMBOL,
        module: %StellarBase.XDR.SCSymbol{value: "Hello"},
        type: :symbol,
        value: "Hello"
      },
      %{
        val_type: :SCV_VEC,
        module: %StellarBase.XDR.OptionalSCVec{sc_vec: nil},
        type: :vec,
        value: nil
      },
      %{
        val_type: :SCV_VEC,
        module: %StellarBase.XDR.OptionalSCVec{
          sc_vec: %StellarBase.XDR.SCVec{
            sc_vals: [
              %StellarBase.XDR.SCVal{
                value: %StellarBase.XDR.Int32{datum: 123},
                type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
              }
            ]
          }
        },
        type: :vec,
        value: [sc_val]
      },
      %{
        val_type: :SCV_MAP,
        module: %StellarBase.XDR.OptionalSCMap{sc_map: nil},
        type: :map,
        value: nil
      },
      %{
        val_type: :SCV_MAP,
        module: %StellarBase.XDR.OptionalSCMap{
          sc_map: %StellarBase.XDR.SCMap{
            scmap_entries: [
              %StellarBase.XDR.SCMapEntry{
                key: %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.SCSymbol{value: "sc_val_key"},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
                },
                val: %StellarBase.XDR.SCVal{
                  value: %StellarBase.XDR.Int32{datum: 123},
                  type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
                }
              }
            ]
          }
        },
        type: :map,
        value: [sc_map_entry]
      },
      %{
        val_type: :SCV_CONTRACT_EXECUTABLE,
        module: %StellarBase.XDR.SCContractExecutable{
          contract_executable: %StellarBase.XDR.Hash{value: "hash"},
          type: %StellarBase.XDR.SCContractExecutableType{identifier: :SCCONTRACT_CODE_WASM_REF}
        },
        type: :contract,
        value: {:wasm_ref, "hash"}
      },
      %{
        val_type: :SCV_CONTRACT_EXECUTABLE,
        module: %StellarBase.XDR.SCContractExecutable{
          contract_executable: %StellarBase.XDR.Void{value: nil},
          type: %StellarBase.XDR.SCContractExecutableType{
            identifier: :SCCONTRACT_EXECUTABLE_TOKEN
          }
        },
        type: :contract,
        value: :token
      },
      %{val_type: :SCV_ADDRESS, module: sc_address_xdr, type: :address, value: sc_address},
      %{
        val_type: :SCV_LEDGER_KEY_CONTRACT_EXECUTABLE,
        module: %StellarBase.XDR.Void{value: nil},
        type: :ledger_key_contract,
        value: nil
      },
      %{
        val_type: :SCV_LEDGER_KEY_NONCE,
        module: %StellarBase.XDR.SCNonceKey{nonce_address: sc_address_xdr},
        type: :ledger_key_nonce,
        value: sc_address
      }
    ]

    %{
      sc_status_discriminants: sc_status_discriminants,
      discriminants: discriminants,
      invalid_discriminants: invalid_discriminants,
      xdr_discriminants: xdr_discriminants
    }
  end

  test "new/1", %{discriminants: discriminants} do
    for %{type: type, value: value} <- discriminants do
      %SCVal{type: ^type, value: ^value} = SCVal.new([{type, value}])
    end
  end

  test "new/1 with invalid type" do
    {:error, :invalid_sc_val_type} = SCVal.new(invalid_type: nil)
  end

  test "new/1 with invalid discriminants", %{invalid_discriminants: invalid_discriminants} do
    for %{type: type, value: value} <- invalid_discriminants do
      error = :"invalid_#{type}"
      {:error, ^error} = SCVal.new([{type, value}])
    end
  end

  test "new/1 when type is status", %{sc_status_discriminants: sc_status_discriminants} do
    for %{sc_status: sc_status} <- sc_status_discriminants do
      %SCVal{type: :status, value: ^sc_status} = SCVal.new(status: sc_status)
    end
  end

  test "to_xdr/1", %{xdr_discriminants: xdr_discriminants} do
    for %{val_type: val_type, module: module, type: type, value: value} <- xdr_discriminants do
      %StellarBase.XDR.SCVal{
        type: %StellarBase.XDR.SCValType{identifier: ^val_type},
        value: ^module
      } = SCVal.new([{type, value}]) |> SCVal.to_xdr()
    end
  end
end
