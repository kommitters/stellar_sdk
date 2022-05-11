defmodule Stellar.TxBuild.Claimant do
  @moduledoc """
  `Claimant` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_account_id: 1
    ]

  alias Stellar.TxBuild.AccountID
  alias Stellar.TxBuild.ClaimPredicate, as: TxClaimPredicate
  alias StellarBase.XDR.{ClaimantV0, Claimant, ClaimantType}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{destination: String.t(), predicate: TxClaimPredicate.t()}

  defstruct [:destination, :predicate]

  @impl true
  def new(args, opts \\ [])

  def new({destination, predicate}, _opts),
    do: new(destination: destination, predicate: predicate)

  def new([destination: destination, predicate: predicate], _opts) do
    with {:ok, destination} <- validate_account_id({:destination, destination}),
         {:ok, predicate} <- TxClaimPredicate.validate_predicate(predicate) do
      %__MODULE__{destination: destination, predicate: predicate}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_claimant}

  @impl true
  def to_xdr(%__MODULE__{destination: destination, predicate: predicate}) do
    destination = AccountID.to_xdr(destination)
    claim_predicate = TxClaimPredicate.to_xdr(predicate)
    claimant_type = ClaimantType.new(:CLAIMANT_TYPE_V0)

    destination
    |> ClaimantV0.new(claim_predicate)
    |> Claimant.new(claimant_type)
  end
end
