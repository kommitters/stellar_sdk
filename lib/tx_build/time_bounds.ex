defmodule Stellar.TxBuild.TimeBounds do
  @moduledoc """
  `TimeBounds` struct definition.
  """
  alias StellarBase.XDR.{TimePoint, TimeBounds, OptionalTimeBounds}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{min_time: non_neg_integer(), max_time: non_neg_integer()}

  defstruct [:min_time, :max_time]

  @impl true
  def new(time_bounds \\ {0, 0}, _opts \\ [])

  def new([min_time: min_time, max_time: max_time], _opts), do: new({min_time, max_time})

  def new({min_time, max_time}, _opts) when is_integer(min_time) and is_integer(max_time) do
    %__MODULE__{min_time: min_time, max_time: max_time}
  end

  def new(_min_time, _max_time), do: {:error, :invalid_time_bounds}

  @impl true
  def to_xdr(%__MODULE__{min_time: 0, max_time: 0}) do
    OptionalTimeBounds.new()
  end

  def to_xdr(%__MODULE__{min_time: min_time, max_time: max_time}) do
    min_time = TimePoint.new(min_time)
    max_time = TimePoint.new(max_time)

    min_time
    |> TimeBounds.new(max_time)
    |> OptionalTimeBounds.new()
  end

  @spec set_max_time(max_time :: non_neg_integer()) :: t()
  def set_max_time(max_time) when is_integer(max_time) do
    %__MODULE__{min_time: 0, max_time: max_time}
  end

  def set_max_time(_max_time), do: {:error, :invalid_time_bounds}
end
