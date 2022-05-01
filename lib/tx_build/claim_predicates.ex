defmodule Stellar.TxBuild.ClaimPredicates do
  @moduledoc """
  `ClaimPredicates` struct definition.
  """
  alias Stellar.TxBuild.ClaimPredicate
  alias StellarBase.XDR.ClaimPredicates

  @behaviour Stellar.TxBuild.XDR

  @type predicates :: list(ClaimPredicate.t())
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  defstruct [:value]

  @impl true
  def new(predicates \\ [], opts \\ [])

  def new(predicates, _opts) do
    case validate_predicate_list([], predicates) do
      {:ok, value} -> value
      {:error, value} -> {:error, value}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{value: predicates}) do
    predicates
    |> Enum.map(&ClaimPredicate.to_xdr/1)
    |> ClaimPredicates.new()
  end

  @spec validate_predicate_list(predicates :: predicates, predicates :: predicates()) ::
          validation()
  def validate_predicate_list(response, []), do: {:ok, %__MODULE__{value: response}}

  def validate_predicate_list(response, [%ClaimPredicate{} = h | t]),
    do: validate_predicate_list(response ++ [h], t)

  def validate_predicate_list(_response, _predicates),
    do: {:error, :invalid_predicate_list_value}
end
