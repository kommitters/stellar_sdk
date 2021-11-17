defmodule Stellar.Builder.Structs.OperationsTest do
  use ExUnit.Case

  alias StellarBase.XDR.Operations, as: OperationsXDR
  alias Stellar.Builder.Structs.Operations

  test "new/2" do
    %Operations{operations: []} = Operations.new()
  end

  test "to_xdr/1" do
    %OperationsXDR{operations: []} = Operations.new() |> Operations.to_xdr()
  end
end
