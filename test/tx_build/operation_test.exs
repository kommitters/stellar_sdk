defmodule Stellar.TxBuild.FakeOperation do
  @moduledoc false

  @behaviour Stellar.TxBuild.XDR

  defstruct [:destination, :balance]

  @impl true
  def new(destination, balance) do
    %__MODULE__{destination: destination, balance: balance}
  end

  @impl true
  def to_xdr(_op) do
    :ok
  end
end

defmodule Stellar.TxBuild.OperationTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [create_account_op_xdr: 2, operation_xdr: 1]

  alias Stellar.TxBuild.{Operation, CreateAccount, FakeOperation}

  setup do
    amount = 100
    public_key = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    source_account = "GBFJE2R5ZXJYMVUJHFPHKIQO3PSTKCC42AGYY3WPEY3NPOBYX2NK542R"
    op_body_xdr = create_account_op_xdr(public_key, amount)

    %{
      public_key: public_key,
      amount: amount,
      source_account: source_account,
      op_body: CreateAccount.new(public_key, amount),
      xdr: operation_xdr(op_body_xdr)
    }
  end

  test "new/2", %{op_body: op_body} do
    %Operation{op_body: ^op_body, source_account: nil} = Operation.new(op_body)
  end

  test "new/2 with source_account", %{op_body: op_body, source_account: source_account} do
    %Operation{op_body: ^op_body, source_account: ^source_account} =
      Operation.new(op_body, source_account: source_account)
  end

  test "to_xdr/1", %{xdr: xdr, op_body: op_body} do
    ^xdr =
      op_body
      |> Operation.new()
      |> Operation.to_xdr()
  end

  test "to_xdr/1 invalid_operation" do
    {:error, :invalid_operation} =
      "ABCD"
      |> FakeOperation.new(10)
      |> Operation.new()
      |> Operation.to_xdr()
  end
end
