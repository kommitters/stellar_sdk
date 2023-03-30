defmodule Stellar.TxBuild.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{InvokeHostFunction}

  describe "InvokeHostFunction" do
    setup do
      read_only = "0461168cbbae0da96c543b71fd571aec4b44549d503f9af9e7685ccedbc1613c"
      read_write = "hello"
      %{
        read_only: read_only,
        read_write: read_write
        xdr: InvokeHostFunction(
          read_only: read_only,
          read_write: read_write
        )
      }
    end

    test "new/2", %{read_only: read_only, read_write: read_write} do
      %InvokeHostFunction{
        read_only: ^read_only,
        read_write: ^read_write,
      } = InvokeHostFunction.new(
        read_only: read_only,
        read_write: read_write,
        )
    end

    test "to_xdr/1", %{xdr: xdr, read_only: read_only, read_write: read_write} do
    ^xdr =
      [read_only: read_only, read_write: read_write]
      |> InvokeHostFunction.new()
      |> InvokeHostFunction.to_xdr()
  end
  end
end
