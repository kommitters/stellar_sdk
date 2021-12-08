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
    body_xdr = create_account_op_xdr(public_key, amount)

    %{
      public_key: public_key,
      amount: amount,
      source_account: source_account,
      body: CreateAccount.new(destination: public_key, starting_balance: amount),
      xdr: operation_xdr(body_xdr)
    }
  end

  test "new/2", %{body: body} do
    %Operation{body: ^body, source_account: nil} = Operation.new(body)
  end

  test "new/2 with source_account", %{body: body} do
    %Operation{body: ^body} = Operation.new(body)
  end

  test "new/2 unknown_operation" do
    {:error, :unknown_operation} =
      "ABCD"
      |> FakeOperation.new(10)
      |> Operation.new()
  end

  test "to_xdr/1", %{xdr: xdr, body: body} do
    ^xdr =
      body
      |> Operation.new()
      |> Operation.to_xdr()
  end
end
