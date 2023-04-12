defmodule Stellar.TxBuild.SCValTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{
    SCAddress,
    SCStatus,
    SCVal,
    SCObject,
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

    sc_object_discriminants = [
      %{sc_object: SCObject.new(vec: [sc_val])},
      %{sc_object: SCObject.new(map: [sc_map_entry])},
      %{sc_object: SCObject.new(u64: 123)},
      %{sc_object: SCObject.new(i64: 123)},
      %{sc_object: SCObject.new(u128: %{lo: 123, hi: 321})},
      %{sc_object: SCObject.new(u128: %{lo: 123, hi: 321})},
      %{sc_object: SCObject.new(bytes: "binary")},
      %{sc_object: SCObject.new(contract_code: :token)},
      %{sc_object: SCObject.new(address: sc_address)},
      %{sc_object: SCObject.new(nonce_key: sc_address)}
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

    %{
      sc_object_discriminants: sc_object_discriminants,
      sc_status_discriminants: sc_status_discriminants
    }
  end

  test "new/1 when type is u63" do
    %SCVal{type: :u63, value: 123} = SCVal.new(u63: 123)
  end

  test "new/1 when type u63 is incorrect" do
    {:error, :invalid_u63} = SCVal.new(u63: "123")
  end

  test "new/1 when type is u32" do
    %SCVal{type: :u32, value: 123} = SCVal.new(u32: 123)
  end

  test "new/1 when type u32 is incorrect" do
    {:error, :invalid_u32} = SCVal.new(u32: "123")
  end

  test "new/1 when type is i32" do
    %SCVal{type: :i32, value: 123} = SCVal.new(i32: 123)
  end

  test "new/1 when type i32 is incorrect" do
    {:error, :invalid_i32} = SCVal.new(i32: "123")
  end

  test "new/1 when type is static" do
    %SCVal{type: :static, value: :void} = SCVal.new(static: :void)
    %SCVal{type: :static, value: true} = SCVal.new(static: true)
    %SCVal{type: :static, value: false} = SCVal.new(static: false)

    %SCVal{type: :static, value: :ledger_contract_code} = SCVal.new(static: :ledger_contract_code)
  end

  test "new/1 when type static is incorrect" do
    {:error, :invalid_static} = SCVal.new(static: "123")
  end

  test "new/1 when type is object", %{sc_object_discriminants: sc_object_discriminants} do
    for %{sc_object: sc_object} <- sc_object_discriminants do
      %SCVal{type: :object, value: ^sc_object} = SCVal.new(object: sc_object)
    end
  end

  test "new/1 when type object is incorrect" do
    sc_object = SCObject.new(:u64, "123")
    {:error, :invalid_object} = SCVal.new(object: sc_object)
  end

  test "new/1 when type is symbol" do
    %SCVal{type: :symbol, value: "symbol"} = SCVal.new(symbol: "symbol")
  end

  test "new/1 when type symbol is incorrect" do
    {:error, :invalid_symbol} = SCVal.new(symbol: 123)
  end

  test "new/1 when type is bitset" do
    %SCVal{type: :bitset, value: 123} = SCVal.new(bitset: 123)
  end

  test "new/1 when type bitset is incorrect" do
    {:error, :invalid_bitset} = SCVal.new(bitset: "123")
  end

  test "new/1 when type is status", %{sc_status_discriminants: sc_status_discriminants} do
    for %{sc_status: sc_status} <- sc_status_discriminants do
      %SCVal{type: :status, value: ^sc_status} = SCVal.new(status: sc_status)
    end
  end

  test "new/1 when type is invalid" do
    {:error, :invalid_sc_val_type} = SCVal.new(invalid_type: "invalid_type")
  end

  test "to_xdr when type is u63" do
    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_U63},
      value: %StellarBase.XDR.UInt64{datum: 123}
    } = SCVal.new(u63: 123) |> SCVal.to_xdr()
  end

  test "to_xdr when type is u32" do
    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_U32},
      value: %StellarBase.XDR.UInt32{datum: 123}
    } = SCVal.new(u32: 123) |> SCVal.to_xdr()
  end

  test "to_xdr when type is i32" do
    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_I32},
      value: %StellarBase.XDR.Int32{datum: 123}
    } = SCVal.new(i32: 123) |> SCVal.to_xdr()
  end

  test "to_xdr when type is static" do
    %StellarBase.XDR.SCVal{
      value: %StellarBase.XDR.SCStatic{identifier: :SCS_VOID},
      type: %StellarBase.XDR.SCValType{identifier: :SCV_STATIC}
    } = SCVal.new(static: :void) |> SCVal.to_xdr()
  end

  test "to_xdr when type is object" do
    sc_object = SCObject.new(u64: 123)

    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_OBJECT},
      value: %StellarBase.XDR.OptionalSCObject{
        sc_object: %StellarBase.XDR.SCObject{
          sc_object: %StellarBase.XDR.UInt64{datum: 123},
          type: %StellarBase.XDR.SCObjectType{identifier: :SCO_U64}
        }
      }
    } = SCVal.new(object: sc_object) |> SCVal.to_xdr()
  end

  test "to_xdr when type is symbol" do
    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL},
      value: %StellarBase.XDR.SCSymbol{value: "symbol"}
    } = SCVal.new(symbol: "symbol") |> SCVal.to_xdr()
  end

  test "to_xdr when type is bitset" do
    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_BITSET},
      value: %StellarBase.XDR.UInt64{datum: 123}
    } = SCVal.new(bitset: 123) |> SCVal.to_xdr()
  end

  test "to_xdr when type is status" do
    sc_status = SCStatus.new(unknown_error: :UNKNOWN_ERROR_GENERAL)

    %StellarBase.XDR.SCVal{
      type: %StellarBase.XDR.SCValType{identifier: :SCV_STATUS},
      value: %StellarBase.XDR.SCStatus{
        code: %StellarBase.XDR.SCUnknownErrorCode{
          identifier: :UNKNOWN_ERROR_GENERAL
        },
        type: %StellarBase.XDR.SCStatusType{identifier: :SST_UNKNOWN_ERROR}
      }
    } = SCVal.new(status: sc_status) |> SCVal.to_xdr()
  end
end
