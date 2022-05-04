defmodule Stellar.TxBuild.Ledger.Account do
  @moduledoc """
  Ledger `Account` struct definition.
  """
  alias StellarBase.XDR.Account
  alias Stellar.TxBuild.AccountID

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{account_id: AccountID.t()}

  defstruct [:account_id]

  @impl true
  def new(account_id, opts \\ [])

  def new(account_id, _opts) do
    case AccountID.new(account_id) do
      %AccountID{} = account_id -> %__MODULE__{account_id: account_id}
      error -> error
    end
  end

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id}) do
    account_id
    |> AccountID.to_xdr()
    |> Account.new()
  end
end
