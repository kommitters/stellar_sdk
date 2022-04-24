defmodule Stellar.TxBuild.OptionalClaimPredicate do
  @moduledoc """
  `OptionalClaimPredicate` struct definition.
  """
  alias StellarBase.XDR.OptionalClaimPredicate
  alias Stellar.TxBuild.ClaimPredicate

  @behaviour Stellar.TxBuild.XDR

  @type predicate :: ClaimPredicate.t() | nil

  defstruct [:value]

  @impl true
  def new(predicate \\ nil, opts \\ [])

  def new(%ClaimPredicate{} = predicate, _opts) do
    %__MODULE__{value: predicate}
  end

  def new(nil, _opts), do: %__MODULE__{value: nil}

  def new(_args, _opts), do: {:error, :invalid_optional_claim_predicate}

  @impl true
  def to_xdr(%__MODULE__{value: nil}), do: OptionalClaimPredicate.new()

  def to_xdr(%__MODULE__{value: predicate}) do
    predicate
    |> ClaimPredicate.to_xdr()
    |> OptionalClaimPredicate.new()
  end
end
