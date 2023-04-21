defmodule Stellar.TxBuild.SCMapEntryTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{SCMapEntry, SCVal}

  setup do
    key = SCVal.new(i32: 21)
    val = SCVal.new(string: "string")

    %{
      key: key,
      val: val,
      to_xdr: %StellarBase.XDR.SCMapEntry{
        key: %StellarBase.XDR.SCVal{
          value: %StellarBase.XDR.Int32{datum: 21},
          type: %StellarBase.XDR.SCValType{identifier: :SCV_I32}
        },
        val: %StellarBase.XDR.SCVal{
          value: %StellarBase.XDR.SCString{value: "string"},
          type: %StellarBase.XDR.SCValType{identifier: :SCV_STRING}
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
