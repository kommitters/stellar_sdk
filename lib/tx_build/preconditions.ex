defmodule Stellar.TxBuild.Preconditions do
  @moduledoc """
  `Preconditions` struct definition.
  """
  alias Stellar.TxBuild.{
    TimeBounds,
    LedgerBounds,
    SequenceNumber,
    SignerKey
  }

  alias StellarBase.XDR.TimeBounds, as: TimeBoundsXDR

  alias StellarBase.XDR.{
    Preconditions,
    PreconditionsV2,
    PreconditionType,
    Duration,
    OptionalSequenceNumber,
    SignerKeyList,
    TimePoint,
    UInt32,
    Void
  }

  @behaviour Stellar.TxBuild.XDR

  @type precond_v2 :: %{
          time_bounds: TimeBounds.t(),
          ledger_bounds: LedgerBounds.t(),
          min_seq_num: SequenceNumber.t(),
          min_seq_age: non_neg_integer(),
          min_seq_ledger_gap: non_neg_integer(),
          extra_signers: list(SignerKey.t())
        }
  @type validation ::
          {:ok, non_neg_integer()} | {:ok, struct()} | {:ok, list(struct())} | {:error, atom()}
  @type type :: :precond_v2 | :precond_time | :none
  @type preconditions :: precond_v2() | TimeBounds.t() | nil

  @type t :: %__MODULE__{type: type(), preconditions: preconditions()}

  defstruct [:type, :preconditions]

  @impl true
  def new(preconditions \\ [], opts \\ [])

  def new([], _opts) do
    %__MODULE__{type: :none, preconditions: nil}
  end

  def new([time_bounds: %TimeBounds{} = time_bounds], _opts) do
    %__MODULE__{type: :precond_time, preconditions: time_bounds}
  end

  def new(preconditions, _opts) do
    time_bounds = Keyword.get(preconditions, :time_bounds)
    ledger_bounds = Keyword.get(preconditions, :ledger_bounds)
    min_seq_num = Keyword.get(preconditions, :min_seq_num)
    min_seq_age = Keyword.get(preconditions, :min_seq_age, 0)
    min_seq_ledger_gap = Keyword.get(preconditions, :min_seq_ledger_gap, 0)
    extra_signers = Keyword.get(preconditions, :extra_signers)

    with {:ok, time_bounds} <- validate_time_bounds(time_bounds),
         {:ok, ledger_bounds} <- validate_ledger_bounds(ledger_bounds),
         {:ok, min_seq_num} <- validate_min_seq_num(min_seq_num),
         {:ok, min_seq_age} <- validate_min_seq_age(min_seq_age),
         {:ok, min_seq_ledger_gap} <- validate_min_seq_ledger_gap(min_seq_ledger_gap),
         {:ok, extra_signers} <- validate_extra_signers([], extra_signers) do
      %__MODULE__{
        type: :precond_v2,
        preconditions: %{
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        }
      }
    end
  end

  @impl true
  def to_xdr(%__MODULE__{type: :none, preconditions: nil}) do
    preconditions_type = PreconditionType.new(:PRECOND_NONE)

    Preconditions.new(Void.new(), preconditions_type)
  end

  def to_xdr(%__MODULE__{
        type: :precond_time,
        preconditions: %TimeBounds{min_time: min_time, max_time: max_time}
      }) do
    preconditions_type = PreconditionType.new(:PRECOND_TIME)

    min_time = TimePoint.new(min_time)
    max_time = TimePoint.new(max_time)

    min_time
    |> TimeBoundsXDR.new(max_time)
    |> Preconditions.new(preconditions_type)
  end

  def to_xdr(%__MODULE__{
        type: :precond_v2,
        preconditions: %{
          time_bounds: time_bounds,
          ledger_bounds: ledger_bounds,
          min_seq_num: min_seq_num,
          min_seq_age: min_seq_age,
          min_seq_ledger_gap: min_seq_ledger_gap,
          extra_signers: extra_signers
        }
      }) do
    preconditions_type = PreconditionType.new(:PRECOND_V2)

    time_bounds = TimeBounds.to_xdr(time_bounds)
    ledger_bounds = LedgerBounds.to_xdr(ledger_bounds)
    min_seq_num = min_seq_num |> SequenceNumber.to_xdr() |> OptionalSequenceNumber.new()
    min_seq_age = Duration.new(min_seq_age)
    min_seq_ledger_gap = UInt32.new(min_seq_ledger_gap)

    extra_signers =
      extra_signers
      |> Enum.map(&SignerKey.to_xdr(&1))
      |> SignerKeyList.new()

    time_bounds
    |> PreconditionsV2.new(
      ledger_bounds,
      min_seq_num,
      min_seq_age,
      min_seq_ledger_gap,
      extra_signers
    )
    |> Preconditions.new(preconditions_type)
  end

  @spec validate_time_bounds(time_bounds :: TimeBounds.t()) :: validation()
  defp validate_time_bounds(%TimeBounds{} = time_bounds), do: {:ok, time_bounds}
  defp validate_time_bounds(_time_bounds), do: {:error, :invalid_time_bounds}

  @spec validate_ledger_bounds(ledger_bounds :: LedgerBounds.t()) :: validation()
  defp validate_ledger_bounds(%LedgerBounds{} = ledger_bounds),
    do: {:ok, ledger_bounds}

  defp validate_ledger_bounds(_ledger_bounds), do: {:error, :invalid_ledger_bounds}

  @spec validate_min_seq_num(min_seq_num :: SequenceNumber.t()) :: validation()
  defp validate_min_seq_num(%SequenceNumber{} = min_seq_num),
    do: {:ok, min_seq_num}

  defp validate_min_seq_num(_min_seq_num), do: {:error, :invalid_min_seq_num}

  @spec validate_min_seq_age(min_seq_age :: non_neg_integer()) :: validation()
  defp validate_min_seq_age(min_seq_age)
       when is_integer(min_seq_age) and min_seq_age >= 0,
       do: {:ok, min_seq_age}

  defp validate_min_seq_age(_min_seq_age), do: {:error, :invalid_min_seq_age}

  @spec validate_min_seq_ledger_gap(min_seq_ledger_gap :: non_neg_integer()) :: validation()
  defp validate_min_seq_ledger_gap(min_seq_ledger_gap)
       when is_integer(min_seq_ledger_gap) and min_seq_ledger_gap >= 0,
       do: {:ok, min_seq_ledger_gap}

  defp validate_min_seq_ledger_gap(_min_seq_ledger_gap), do: {:error, :invalid_min_seq_ledger_gap}

  @spec validate_extra_signers(
          response :: list(String.t()),
          extra_signers :: list(String.t())
        ) :: validation()
  def validate_extra_signers(response, []), do: {:ok, response}

  def validate_extra_signers(response, [h | t]) do
    case SignerKey.new(h) do
      %SignerKey{} = signer_key -> validate_extra_signers(response ++ [signer_key], t)
      _error -> {:error, :invalid_extra_signers}
    end
  end

  def validate_extra_signers(_response, _extra_signers),
    do: {:error, :invalid_extra_signers}
end
