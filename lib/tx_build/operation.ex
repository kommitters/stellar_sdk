defmodule Stellar.TxBuild.Operation do
  @moduledoc """
  `Operation` struct definition.
  """
  alias Stellar.TxBuild.CreateAccount
  alias StellarBase.XDR.{Operation, OperationBody, OperationType, OptionalMuxedAccount}

  @behaviour Stellar.TxBuild.XDR

  @type op_body :: CreateAccount.t()

  @type source_account :: String.t() | nil

  @type t :: %__MODULE__{op_body: op_body(), source_account: source_account()}

  defstruct [:op_body, :source_account]

  @impl true
  def new(op_body, opts \\ []) do
    source_account = Keyword.get(opts, :source_account, nil)
    %__MODULE__{op_body: op_body, source_account: source_account}
  end

  @impl true
  def to_xdr(%__MODULE__{op_body: %CreateAccount{} = op_body, source_account: source_account}) do
    op_type = OperationType.new(:CREATE_ACCOUNT)

    op_body
    |> CreateAccount.to_xdr()
    |> operation_xdr(op_type, source_account)
  end

  def to_xdr(_operation), do: {:error, :invalid_operation}

  @spec operation_xdr(
          op_body :: struct(),
          op_type :: struct(),
          source_account :: source_account()
        ) :: Operation.t()
  defp operation_xdr(op_body, op_type, source_account) do
    source_account = OptionalMuxedAccount.new(source_account)

    op_body
    |> OperationBody.new(op_type)
    |> (&Operation.new(source_account, &1)).()
  end
end
