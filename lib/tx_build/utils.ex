defmodule Stellar.TxBuild.Utils do
  @moduledoc """
  TxBuild utils functions.
  """
  @type fraction :: {integer(), integer()}

  @spec number_to_fraction(number :: number()) :: fraction()
  def number_to_fraction(number) when is_integer(number), do: {number, 1}

  def number_to_fraction(number) when is_float(number) do
    precision = float_precision(number)
    base = :math.pow(10, precision) |> trunc()

    numerator = trunc(number * base)
    denominator = 1 * base
    gcd = Integer.gcd(numerator, denominator)

    {div(numerator, gcd), div(denominator, gcd)}
  end

  @spec float_precision(number :: float()) :: integer()
  defp float_precision(number) do
    number
    |> Float.to_string()
    |> String.split(".")
    |> List.last()
    |> String.length()
  end
end
