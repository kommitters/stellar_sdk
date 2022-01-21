defmodule Stellar.Horizon.Mapping do
  @moduledoc """
  Takes a result map or list of maps from Horizon response and returns a struct
  (e.g. `%Horizon.Resource.Transaction{}`) or list of structs.
  """

  @type attr_type :: :integer | :float | :date_time | struct()
  @type attr_value :: String.t() | integer() | float() | boolean() | struct() | list() | nil

  @spec build(module :: struct(), attrs :: map()) :: struct()
  def build(module, attrs) do
    attrs =
      module
      |> Map.from_struct()
      |> Map.keys()
      |> (&Map.take(attrs, &1)).()

    struct!(module, attrs)
  end

  @spec parse(module :: struct(), mapping :: Keyword.t()) :: struct()
  def parse(module, []), do: module

  def parse(module, [{attr, type} | attrs]) do
    value = Map.get(module, attr)
    parsed_value = do_parse(type, value)

    module
    |> Map.put(attr, parsed_value)
    |> parse(attrs)
  end

  @spec do_parse(type :: attr_type(), value :: attr_value()) :: attr_value()
  defp do_parse(:integer, value) when is_bitstring(value), do: String.to_integer(value)

  defp do_parse(:float, value) when is_bitstring(value), do: String.to_float(value)

  defp do_parse(:date_time, value) when is_bitstring(value) do
    case DateTime.from_iso8601(value) do
      {:ok, date_time, _offset} -> date_time
      _error -> value
    end
  end

  defp do_parse(%{__struct__: module}, values) when is_list(values) do
    Enum.map(values, &module.new(&1))
  end

  defp do_parse(%{__struct__: module}, value) when not is_nil(value), do: module.new(value)

  defp do_parse(_type, value), do: value
end
