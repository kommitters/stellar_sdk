defmodule Stellar.TxBuild.ClaimPredicate do
  @moduledoc """
  `ClaimPredicate` struct definition.
  """
  alias Stellar.TxBuild.{ClaimPredicates, OptionalClaimPredicate}
  alias StellarBase.XDR.{ClaimPredicate, ClaimPredicateType, Int64, Void}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, any()}
  @type predicate :: :unconditional | :conditional
  @type type :: :time | :and | :or | :not
  @type time_type :: :relative | :absolute
  @type value :: t() | ClaimPredicates.t() | pos_integer()

  @type t :: %__MODULE__{
          predicate: predicate(),
          value: value(),
          type: type(),
          time_type: time_type()
        }

  defstruct [:predicate, :value, :type, :time_type]

  @impl true
  def new(args, opts \\ [])

  def new(:unconditional, _opts), do: %__MODULE__{predicate: :unconditional}

  def new({value, type, time_type}, _opts),
    do: new(value: value, type: type, time_type: time_type)

  def new([value: value, type: type], _opts)
      when type in ~w(and or not)a do
    case validate_predicate_value(value, type) do
      {:ok, value} ->
        %__MODULE__{predicate: :conditional, type: type, value: value, time_type: nil}

      {:error, value} ->
        {:error, value}
    end
  end

  def new([value: value, type: type, time_type: time_type], _opts) do
    case validate_predicate_value(value, type) do
      {:ok, value} ->
        %__MODULE__{predicate: :conditional, type: :time, value: value, time_type: time_type}

      {:error, value} ->
        {:error, value}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_claim_predicate}

  @impl true
  @spec to_xdr(Stellar.TxBuild.ClaimPredicate.t()) :: StellarBase.XDR.ClaimPredicate.t()
  def to_xdr(%__MODULE__{predicate: :unconditional}) do
    Void.new()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_UNCONDITIONAL))
  end

  def to_xdr(%__MODULE__{value: value, type: :and}) do
    value
    |> ClaimPredicates.to_xdr()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_AND))
  end

  def to_xdr(%__MODULE__{value: value, type: :or}) do
    value
    |> ClaimPredicates.to_xdr()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_OR))
  end

  def to_xdr(%__MODULE__{value: value, type: :not}) do
    value
    |> OptionalClaimPredicate.new()
    |> OptionalClaimPredicate.to_xdr()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_NOT))
  end

  def to_xdr(%__MODULE__{value: value, time_type: :absolute}) do
    value
    |> Int64.new()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_BEFORE_ABSOLUTE_TIME))
  end

  def to_xdr(%__MODULE__{value: value, time_type: :relative}) do
    value
    |> Int64.new()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_BEFORE_RELATIVE_TIME))
  end

  @spec validate_predicate_value(value :: value(), type :: atom()) :: validation()
  defp validate_predicate_value(%__MODULE__{} = value, type)
       when type != :time,
       do: {:ok, value}

  defp validate_predicate_value(value, type) when is_integer(value) and type == :time,
    do: {:ok, value}

  defp validate_predicate_value(%ClaimPredicates{value: value}, type)
       when is_list(value) and length(value) == 2 and
              type in ~w(and or)a,
       do: ClaimPredicates.validate_predicate_list([], value)

  defp validate_predicate_value(_value, _type), do: {:error, :invalid_predicate_value}
end
