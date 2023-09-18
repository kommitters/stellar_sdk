defmodule Stellar.TxBuild.SCVecTest do
  use ExUnit.Case

  alias Stellar.TxBuild.SCVec
  alias Stellar.TxBuild.SCVal

  setup do
    items = [
      %SCVal{type: :i64, value: 42},
      %SCVal{type: :string, value: "Hello, World!"}
    ]

    %{
      items: items
    }
  end

  test "new/1", %{items: items} do
    %SCVec{items: ^items} = SCVec.new(items)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_vec} = SCVec.new([42, "Hello, World!"])
  end

  test "new/1 with invalid items" do
    {:error, :invalid_sc_vec} = SCVec.new(:invalid)
  end

  test "to_xdr/1", %{items: items} do
    %StellarBase.XDR.SCValList{
      items: [
        %StellarBase.XDR.SCVal{
          value: %StellarBase.XDR.Int64{datum: 42},
          type: %StellarBase.XDR.SCValType{identifier: :SCV_I64}
        },
        %StellarBase.XDR.SCVal{
          value: %StellarBase.XDR.SCString{value: "Hello, World!"},
          type: %StellarBase.XDR.SCValType{identifier: :SCV_STRING}
        }
      ]
    } =
      items
      |> SCVec.new()
      |> SCVec.to_xdr()
  end
end
