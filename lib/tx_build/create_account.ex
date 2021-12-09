defmodule Stellar.TxBuild.CreateAccount do
  @moduledoc """
  `CreateAccountOp` struct definition.
  """
  alias Stellar.TxBuild.{AccountID, Amount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.CreateAccount}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, atom()}

  @type source_account :: String.t() | nil

  @type t :: %__MODULE__{
          destination: AccountID.t(),
          starting_balance: Amount.t(),
          source_account: source_account()
        }

  defstruct [:destination, :starting_balance, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    destination = Keyword.get(args, :destination)
    starting_balance = Keyword.get(args, :starting_balance)
    source_account = Keyword.get(args, :source_account)

    with {:ok, destination} <- validate_destination(destination),
         {:ok, starting_balance} <- validate_starting_balance(starting_balance) do
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

  @spec validate_destination(destination :: String.t()) :: validation()
  defp validate_destination(destination) do
    case AccountID.new(destination) do
      %AccountID{} = destination -> {:ok, destination}
      _error -> {:error, :invalid_destination}
    end
  end

  @spec validate_starting_balance(starting_balance :: String.t()) :: validation()
  defp validate_starting_balance(starting_balance) do
    case Amount.new(starting_balance) do
      %Amount{} = starting_balance -> {:ok, starting_balance}
      _error -> {:error, :invalid_starting_balance}
    end
  end
end
