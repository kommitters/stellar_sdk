defmodule Stellar.TxBuild.ClawbackClaimableBalance do
  @moduledoc """
  Creates a clawback operation for a claimable balance.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{ClaimableBalanceID, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.ClawbackClaimableBalance}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          claimable_balance_id: ClaimableBalanceID.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:claimable_balance_id, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    claimable_balance_id = Keyword.get(args, :claimable_balance_id)
    source_account = Keyword.get(args, :source_account)

    with {:ok, claimable_balance_id} <-
           validate_claimable_balance_id({:claimable_balance_id, claimable_balance_id}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{claimable_balance_id: claimable_balance_id, source_account: source_account}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{claimable_balance_id: claimable_balance_id}) do
    op_type = OperationType.new(:CLAWBACK_CLAIMABLE_BALANCE)

    claimable_balance_id
    |> ClaimableBalanceID.to_xdr()
    |> ClawbackClaimableBalance.new()
    |> OperationBody.new(op_type)
  end
end
