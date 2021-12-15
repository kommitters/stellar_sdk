defmodule Stellar.TxBuild.AccountMerge do
  @moduledoc """
  Transfers the native balance (the amount of XLM an account holds) to another account and removes the source account from the ledger.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{Account, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.AccountMerge}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{destination: Account.t(), source_account: OptionalAccount.t()}

  defstruct [:destination, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    destination = Keyword.get(args, :destination)
    source_account = Keyword.get(args, :source_account)

    with {:ok, destination} <- validate_account({:destination, destination}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{destination: destination, source_account: source_account}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{destination: destination}) do
    op_type = OperationType.new(:ACCOUNT_MERGE)

    destination
    |> Account.to_xdr()
    |> AccountMerge.new()
    |> OperationBody.new(op_type)
  end
end
