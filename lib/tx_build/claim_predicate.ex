defmodule Stellar.TxBuild.ClaimPredicate do
  @moduledoc """
  `ClaimPredicate` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_predicate_list: 2
    ]

  alias Stellar.TxBuild.{ClaimPredicates, OptionalClaimPredicate}
  alias StellarBase.XDR.{ClaimPredicate, ClaimPredicateType, Int64, Void}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, any()}
  @type predicate :: :unconditional | :conditional
  @type type :: :time | :and | :or | :not
  @type time_type :: :relative | :absolute
  @type value :: t() | list(t()) | pos_integer()

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
      when type === :and or type === :or or type === :not do
    with {:ok, value} <- validate_predicate_value(value, type) do
      %__MODULE__{predicate: :conditional, type: type, value: value, time_type: nil}
    end
  end

  def new([value: value, type: type, time_type: time_type], _opts) do
    with {:ok, value} <- validate_predicate_value(value, type) do
      %__MODULE__{predicate: :conditional, type: :time, value: value, time_type: time_type}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_claim_predicate}

  @impl true
  def to_xdr(%__MODULE__{predicate: :unconditional}) do
    ClaimPredicate.new(Void.new(), ClaimPredicateType.new(:CLAIM_PREDICATE_UNCONDITIONAL))
  end

  def to_xdr(%__MODULE__{value: value, type: :and}) do
    value
    |> ClaimPredicates.new()
    |> ClaimPredicates.to_xdr()
    |> ClaimPredicate.new(ClaimPredicateType.new(:CLAIM_PREDICATE_AND))
  end

  def to_xdr(%__MODULE__{value: value, type: :or}) do
    value
    |> ClaimPredicates.new()
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

  defp validate_predicate_value(value, type)
       when is_list(value) and length(value) == 2 and
              (type === :and or type === :or),
       do: validate_predicate_list([], value)

  defp validate_predicate_value(_value, _type), do: {:error, :invalid_predicate_value}
end
