defmodule Stellar.TxBuild.TimeBounds do
  @moduledoc """
  `TimeBounds` struct definition.
  """
  alias StellarBase.XDR.{TimePoint, TimeBounds, OptionalTimeBounds}

  @behaviour Stellar.TxBuild.Spec

  @type t :: %__MODULE__{min_time: non_neg_integer(), max_time: non_neg_integer()}

  defstruct [:min_time, :max_time]

  @impl true
  def new(min_time \\ 0, max_time \\ 0) do
    %__MODULE__{min_time: min_time, max_time: max_time}
  end

  @impl true
  def to_xdr(%__MODULE__{min_time: 0, max_time: 0}) do
    OptionalTimeBounds.new(nil)
  end

  def to_xdr(%__MODULE__{min_time: min_time, max_time: max_time}) do
    min_time = TimePoint.new(min_time)
    max_time = TimePoint.new(max_time)

    min_time
    |> TimeBounds.new(max_time)
    |> OptionalTimeBounds.new()
  end

  @spec set_max_time(max_time :: non_neg_integer()) :: t()
  def set_max_time(max_time) do
    %__MODULE__{min_time: 0, max_time: max_time}
  end
end
