defmodule Stellar.TxBuild.FootPrintTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{FootPrint, LedgerKey}

  describe "FootPrint" do
    setup do
      read_only = []
      read_write = []
      %{
        read_only: read_only,
        read_write: read_write
        xdr: FootPrint(
          read_only: read_only,
          read_write: read_write
        )
      }
    end

    test "new/2", %{read_only: read_only, read_write: read_write} do
      %FootPrint{
        read_only: ^read_only,
        read_write: ^read_write,
      } = FootPrint.new(
        read_only: read_only,
        read_write: read_write,
        )
    end

    test "to_xdr/1", %{xdr: xdr, read_only: read_only, read_write: read_write} do
    ^xdr =
      [read_only: read_only, read_write: read_write]
      |> FootPrint.new()
      |> FootPrint.to_xdr()
  end
  end
end
