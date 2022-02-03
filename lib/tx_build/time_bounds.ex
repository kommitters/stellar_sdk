defmodule Stellar.TxBuild.TimeBounds do
  @moduledoc """
  `TimeBounds` struct definition.
  """
  alias StellarBase.XDR.{TimePoint, TimeBounds, OptionalTimeBounds}

  @behaviour Stellar.TxBuild.XDR

  @type date_time :: DateTime.t() | non_neg_integer()
  @type unix_date_time :: non_neg_integer()
  @type validation :: {:ok, unix_date_time()} | {:error, :atom}

  @type t :: %__MODULE__{min_time: unix_date_time(), max_time: unix_date_time()}

  defstruct [:min_time, :max_time]

  @impl true
  def new(time_bounds \\ [min_time: 0, max_time: 0], opts \\ [])

  def new(:none, _opts), do: new(min_time: 0, max_time: 0)

  def new([min_time: min_time, max_time: max_time], _opts) do
    with {:ok, min_time} <- validate_date_time(min_time),
         {:ok, max_time} <- validate_date_time(max_time) do
      %__MODULE__{min_time: min_time, max_time: max_time}
    end
  end

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

  @spec set_timeout(max_time :: date_time()) :: t() | {:error, atom()}
  def set_timeout(max_time), do: new(min_time: 0, max_time: max_time)

  @spec validate_date_time(date_time :: date_time()) :: validation()
  defp validate_date_time(%DateTime{} = date_time) do
    {:ok, DateTime.to_unix(date_time)}
  end

  defp validate_date_time(date_time) when is_integer(date_time) and date_time >= 0,
    do: {:ok, date_time}

  defp validate_date_time(_date_time), do: {:error, :invalid_time_bounds}
end
