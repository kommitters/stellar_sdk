defmodule Stellar.TxBuild.CreateAccount do
  @moduledoc """
  Creates and funds a new account with the specified starting balance.
  """
  import Stellar.TxBuild.Validations,
    only: [validate_account_id: 1, validate_amount: 1, validate_optional_account: 1]

  alias Stellar.TxBuild.{AccountID, Amount, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.CreateAccount}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          destination: AccountID.t(),
          starting_balance: Amount.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:destination, :starting_balance, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    destination = Keyword.get(args, :destination)
    starting_balance = Keyword.get(args, :starting_balance)
    source_account = Keyword.get(args, :source_account)

    with {:ok, destination} <- validate_account_id({:destination, destination}),
         {:ok, starting_balance} <- validate_amount({:starting_balance, starting_balance}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        destination: destination,
        starting_balance: starting_balance,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{destination: destination, starting_balance: starting_balance}) do
    op_type = OperationType.new(:CREATE_ACCOUNT)
    destination = AccountID.to_xdr(destination)
    amount = Amount.to_xdr(starting_balance)

    destination
    |> CreateAccount.new(amount)
    |> OperationBody.new(op_type)
  end
end
