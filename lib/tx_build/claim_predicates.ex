defmodule Stellar.TxBuild.ClaimPredicates do
  @moduledoc """
  `ClaimPredicates` struct definition.
  """
  alias Stellar.TxBuild.ClaimPredicate
  alias StellarBase.XDR.ClaimPredicates

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, error()}
  @type predicates :: ClaimPredicate.t() | list(ClaimPredicate.t())
  @type error :: {:error, atom()}
  @type t :: %__MODULE__{value: list(ClaimPredicate.t())}

  defstruct [:value]

  @impl true
  def new(predicates \\ [], opts \\ [])

  def new(predicates, _opts) do
    with {:ok, value} <- validate_predicate_list([], predicates) do
      %__MODULE__{value: value}
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
  def validate_predicate_list(response, []), do: {:ok, response}

  def validate_predicate_list(response, [%ClaimPredicate{} = h | t]),
    do: validate_predicate_list(response ++ [h], t)

  def validate_predicate_list(_response, _predicates),
    do: {:error, :invalid_predicate_list_value}
end
