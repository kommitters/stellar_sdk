defmodule Stellar.TxBuild.CreateAccount do
  @moduledoc """
  `CreateAccountOp` struct definition.
  """
  alias Stellar.TxBuild.{AccountID, Amount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.CreateAccount}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}

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

    with %AccountID{} = account_id <- AccountID.new(destination),
         %Amount{} = amount <- Amount.new(starting_balance) do
      %__MODULE__{
        destination: account_id,
        starting_balance: amount,
        source_account: source_account
      }
    else
      error -> error_message(error)
    end
  end

  def new(_args, _opts), do: {:error, :invalid_arguments}

  @impl true
  def to_xdr(%__MODULE__{destination: destination, starting_balance: starting_balance}) do
    op_type = OperationType.new(:CREATE_ACCOUNT)
    destination = AccountID.to_xdr(destination)
    amount = Amount.to_xdr(starting_balance)

    destination
    |> CreateAccount.new(amount)
    |> OperationBody.new(op_type)
  end

  @spec error_message(error :: error()) :: error()
  defp error_message({:error, :invalid_account_id}), do: {:error, :invalid_destination}
  defp error_message({:error, :invalid_amount}), do: {:error, :invalid_starting_balance}
end
