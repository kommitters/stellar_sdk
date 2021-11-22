defmodule Stellar.TxBuild.OperationsTest do
  use ExUnit.Case

  alias StellarBase.XDR.Operations, as: OperationsXDR
  alias Stellar.TxBuild.Operations

  setup do
    %{operations: Operations.new()}
  end

  test "new/2" do
    %Operations{operations: []} = Operations.new()
  end

  test "add/1", %{operations: operations} do
    %Operations{operations: [:test]} = Operations.add(operations, :test)
  end

  test "to_xdr/1", %{operations: operations} do
    %OperationsXDR{operations: []} = Operations.to_xdr(operations)
  end
end
