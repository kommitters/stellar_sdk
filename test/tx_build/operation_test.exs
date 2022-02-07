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

  import Stellar.Test.XDRFixtures, only: [create_account_op_xdr: 2, operation_xdr: 2]

  alias Stellar.TxBuild.{Operation, CreateAccount, FakeOperation, OptionalAccount}

  setup do
    amount = 100
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    source_account_id = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    source_account = OptionalAccount.new(source_account_id)

    body =
      CreateAccount.new(
        destination: account_id,
        starting_balance: amount,
        source_account: source_account_id
      )

    body_xdr = create_account_op_xdr(account_id, amount)

    %{
      account_id: account_id,
      amount: amount,
      source_account: source_account,
      body: body,
      xdr: operation_xdr(body_xdr, source_account_id)
    }
  end

  test "new/2", %{body: body} do
    %Operation{body: ^body} = Operation.new(body)
  end

  test "new/2 with source_account", %{body: body, source_account: source_account} do
    %Operation{body: ^body, source_account: ^source_account} = Operation.new(body)
  end

  test "new/2 unknown_operation" do
    {:error, [unknown_operation: %FakeOperation{}]} =
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
