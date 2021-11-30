defmodule Stellar.TxBuild.CreateAccount do
  @moduledoc """
  `CreateAccountOp` struct definition.
  """
  alias Stellar.TxBuild.{AccountID, Amount}
  alias StellarBase.XDR.Operations.CreateAccount

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{destination: String.t(), starting_balance: non_neg_integer()}

  defstruct [:destination, :starting_balance]

  @impl true
  def new(destination, starting_balance) do
    %__MODULE__{
      destination: AccountID.new(destination),
      starting_balance: Amount.new(starting_balance)
    }
  end

  @impl true
  def to_xdr(%__MODULE__{destination: destination, starting_balance: starting_balance}) do
    CreateAccount.new(
      AccountID.to_xdr(destination),
      Amount.to_xdr(starting_balance)
    )
  end
end
