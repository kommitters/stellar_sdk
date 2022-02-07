defmodule Stellar.TxBuild.OperationsTest do
  use ExUnit.Case

  alias StellarBase.XDR.Operations, as: OperationsXDR
  alias Stellar.TxBuild.{Operation, Operations, CreateAccount}

  setup do
    op_body =
      CreateAccount.new(
        destination: "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V",
        starting_balance: 1.5
      )

    operation = Operation.new(op_body)

    %{
      operation: operation,
      operations: Operations.new()
    }
  end

  test "new/2" do
    %Operations{operations: [], count: 0} = Operations.new()
  end

  test "add/1", %{operations: operations, operation: operation} do
    %Operations{operations: [^operation], count: 1} = Operations.add(operations, operation)
  end

  test "to_xdr/1", %{operations: operations} do
    %OperationsXDR{operations: []} = Operations.to_xdr(operations)
  end
end
