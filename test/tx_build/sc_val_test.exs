defmodule Stellar.TxBuild.SCValTest do
  use ExUnit.Case

  alias StellarBase.XDR.Int64

  alias Stellar.TxBuild.{
    SCAddress,
    SCError,
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
    sc_address = SCAddress.new(public_key)

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
      %{type: :u32, value: 12_345},
      %{type: :i32, value: -12_345},
      %{type: :u64, value: 67_890},
      %{type: :i64, value: -67_890},
      %{type: :time_point, value: 12_345},
      %{type: :duration, value: 67_890},
      %{type: :u128, value: %{lo: -12_345, hi: 12_345}},
      %{type: :i128, value: %{lo: -67_890, hi: 67_890}},
      %{type: :u256, value: %{hi_hi: 123, hi_lo: 123, lo_hi: 123, lo_lo: 123}},
      %{type: :i256, value: %{hi_hi: 123, hi_lo: 123, lo_hi: 123, lo_lo: 123}},
      %{type: :bytes, value: "bytes"},
      %{type: :string, value: "string"},
      %{type: :symbol, value: "symbol"},
      %{type: :vec, value: [sc_val]},
      %{type: :map, value: [sc_map_entry]},
      %{type: :address, value: sc_address},
      %{type: :ledger_key_contract_instance, value: nil},
      %{type: :ledger_key_nonce, value: 132_131},
      %{type: :contract_instance, value: :token},
      %{type: :contract_instance, value: {:wasm_ref, "hash"}}
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
      %{type: :u256, value: %{hi_hi: "123", hi_lo: "123", lo_hi: "123", lo_lo: "123"}},
      %{type: :i256, value: %{hi_hi: "123", hi_lo: "123", lo_hi: "123", lo_lo: "123"}},
      %{type: :bytes, value: :bytes},
      %{type: :string, value: :string},
      %{type: :symbol, value: :symbol},
      %{type: :vec, value: [:sc_val]},
      %{type: :map, value: [:sc_map_entry]},
      %{type: :address, value: :invalid},
      %{type: :ledger_key_nonce, value: :invalid},
      %{type: :contract_instance, value: :invalid}
    ]

    sc_error_discriminants = [
      %{sc_error: SCError.new(contract: :arith_domain)},
      %{sc_error: SCError.new(wasm_vm: :index_bounds)},
      %{sc_error: SCError.new(context: :invalid_input)},
      %{sc_error: SCError.new(storage: :missing_value)},
      %{sc_error: SCError.new(object: :existing_value)},
      %{sc_error: SCError.new(crypto: :exceeded_limit)},
      %{sc_error: SCError.new(events: :invalid_action)},
      %{sc_error: SCError.new(budget: :internal_error)},
      %{sc_error: SCError.new(value: :unexpected_type)},
      %{sc_error: SCError.new(auth: :unexpected_size)}
    ]

    xdr_common_discriminants = [
      %{
        val_type: :SCV_BOOL,
        module: %StellarBase.XDR.Bool{value: true},
        type: :bool,
        value: true
      },
      %{
        val_type: :SCV_VOID,
        module: %StellarBase.XDR.Void{value: nil},
        type: :void,
        value: nil
      },
      %{
        val_type: :SCV_U32,
        module: %StellarBase.XDR.UInt32{datum: 123},
        type: :u32,
        value: 123
      },
      %{
        val_type: :SCV_I32,
        module: %StellarBase.XDR.Int32{datum: 123},
        type: :i32,
        value: 123
      },
      %{
        val_type: :SCV_U64,
        module: %StellarBase.XDR.UInt64{datum: 123},
        type: :u64,
        value: 123
      },
      %{
        val_type: :SCV_I64,
        module: %StellarBase.XDR.Int64{datum: 123},
        type: :i64,
        value: 123
      },
      %{
        val_type: :SCV_U128,
        module: %StellarBase.XDR.UInt128Parts{
          hi: %StellarBase.XDR.UInt64{datum: 123},
          lo: %StellarBase.XDR.UInt64{datum: 123}
        },
        type: :u128,
        value: %{hi: 123, lo: 123}
      },
      %{
        val_type: :SCV_I128,
        module: %StellarBase.XDR.Int128Parts{
          hi: %StellarBase.XDR.Int64{datum: 123},
          lo: %StellarBase.XDR.UInt64{datum: 123}
        },
        type: :i128,
        value: %{hi: 123, lo: 123}
      },
      %{
        val_type: :SCV_U256,
        module: %StellarBase.XDR.UInt256Parts{
          hi_hi: %StellarBase.XDR.UInt64{datum: 123},
          hi_lo: %StellarBase.XDR.UInt64{datum: 123},
          lo_hi: %StellarBase.XDR.UInt64{datum: 123},
          lo_lo: %StellarBase.XDR.UInt64{datum: 123}
        },
        type: :u256,
        value: %{hi_hi: 123, hi_lo: 123, lo_hi: 123, lo_lo: 123}
      },
      %{
        val_type: :SCV_I256,
        module: %StellarBase.XDR.Int256Parts{
          hi_hi: %StellarBase.XDR.Int64{datum: 123},
          hi_lo: %StellarBase.XDR.UInt64{datum: 123},
          lo_hi: %StellarBase.XDR.UInt64{datum: 123},
          lo_lo: %StellarBase.XDR.UInt64{datum: 123}
        },
        type: :i256,
        value: %{hi_hi: 123, hi_lo: 123, lo_hi: 123, lo_lo: 123}
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
            items: [
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
            items: [
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
      }
    ]

    xdr_discriminants =
      [
        %{
          val_type: :SCV_ERROR,
          module: %StellarBase.XDR.SCError{
            type: %StellarBase.XDR.SCErrorType{identifier: :SCE_CONTRACT},
            value: %StellarBase.XDR.SCErrorCode{identifier: :SCEC_ARITH_DOMAIN}
          },
          type: :error,
          value: SCError.new(contract: :arith_domain)
        },
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
          val_type: :SCV_CONTRACT_INSTANCE,
          module: %StellarBase.XDR.SCContractInstance{
            executable: %StellarBase.XDR.ContractExecutable{
              value: %StellarBase.XDR.Hash{value: "hash"},
              type: %StellarBase.XDR.ContractExecutableType{
                identifier: :CONTRACT_EXECUTABLE_WASM
              }
            },
            storage: %StellarBase.XDR.OptionalSCMap{sc_map: nil}
          },
          type: :contract_instance,
          value: {:wasm_ref, "hash"}
        },
        %{
          val_type: :SCV_CONTRACT_INSTANCE,
          module: %StellarBase.XDR.SCContractInstance{
            executable: %StellarBase.XDR.ContractExecutable{
              value: %StellarBase.XDR.Void{value: nil},
              type: %StellarBase.XDR.ContractExecutableType{
                identifier: :CONTRACT_EXECUTABLE_TOKEN
              }
            },
            storage: %StellarBase.XDR.OptionalSCMap{sc_map: nil}
          },
          type: :contract_instance,
          value: :token
        },
        %{val_type: :SCV_ADDRESS, module: sc_address_xdr, type: :address, value: sc_address},
        %{
          val_type: :SCV_LEDGER_KEY_CONTRACT_INSTANCE,
          module: %StellarBase.XDR.Void{value: nil},
          type: :ledger_key_contract_instance,
          value: nil
        },
        %{
          val_type: :SCV_LEDGER_KEY_NONCE,
          module: %StellarBase.XDR.SCNonceKey{nonce: Int64.new(123_654)},
          type: :ledger_key_nonce,
          value: 123_654
        }
      ] ++ xdr_common_discriminants

    native_results = [
      true,
      nil,
      123,
      123,
      123,
      123,
      2_268_949_521_066_274_848_891,
      2_268_949_521_066_274_848_891,
      772_083_513_452_561_733_993_656_830_185_818_400_188_853_745_904_250_009_944_187,
      772_083_513_452_561_733_993_656_830_185_818_400_188_853_745_904_250_009_944_187,
      "Hello",
      "Hello",
      "Hello",
      [],
      [123],
      %{},
      %{"sc_val_key" => 123}
    ]

    %{
      sc_error_discriminants: sc_error_discriminants,
      discriminants: discriminants,
      invalid_discriminants: invalid_discriminants,
      xdr_discriminants: xdr_discriminants,
      xdr_common_discriminants: xdr_common_discriminants,
      native_results: native_results
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

  test "new/1 when type is error", %{sc_error_discriminants: sc_error_discriminants} do
    for %{sc_error: sc_error} <- sc_error_discriminants do
      %SCVal{type: :error, value: ^sc_error} = SCVal.new(error: sc_error)
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

  test "to_native_from_xdr/1" do
    "Hello" = SCVal.to_native_from_xdr("AAAADgAAAAVIZWxsbwAAAA==")
  end

  test "to_native_from_xdr/1 with invalid args" do
    {:error, :invalid_XDR} = SCVal.to_native_from_xdr(123)
  end

  test "to_native_from_xdr/1 with invalid base 64" do
    {:error, :invalid_base64} = SCVal.to_native_from_xdr("invalid_base_64")
  end

  test "to_native/1", %{
    xdr_common_discriminants: xdr_common_discriminants,
    native_results: native_results
  } do
    Enum.zip(xdr_common_discriminants, native_results)
    |> Enum.each(fn {%{type: type, value: value}, native_result} ->
      ^native_result = SCVal.new([{type, value}]) |> SCVal.to_xdr() |> SCVal.to_native()
    end)
  end

  test "to_native/1 with invalid SCVal" do
    {:error, :invalid_or_not_supported_sc_val} = SCVal.to_native("invalid")
  end
end
