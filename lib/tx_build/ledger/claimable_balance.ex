defmodule Stellar.TxBuild.Ledger.ClaimableBalance do
  @moduledoc """
  Ledger `ClaimableBalance` struct definition.
  """
  alias StellarBase.XDR.ClaimableBalance
  alias Stellar.TxBuild.ClaimableBalanceID

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{claimable_balance_id: ClaimableBalanceID.t()}

  defstruct [:claimable_balance_id]

  @impl true
  def new(claimable_balance_id, opts \\ [])

  def new(claimable_balance_id, _opts) do
    case ClaimableBalanceID.new(claimable_balance_id) do
      %ClaimableBalanceID{} = claimable_balance_id ->
        %__MODULE__{claimable_balance_id: claimable_balance_id}

      error ->
        error
    end
  end

  @impl true
  def to_xdr(%__MODULE__{claimable_balance_id: claimable_balance_id}) do
    claimable_balance_id
    |> ClaimableBalanceID.to_xdr()
    |> ClaimableBalance.new()
  end
end
