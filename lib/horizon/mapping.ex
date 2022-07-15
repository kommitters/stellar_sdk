defmodule Stellar.Horizon.Mapping do
  @moduledoc """
  Takes a result map or list of maps from Horizon response and returns a struct
  (e.g. `%Horizon.Transaction{}`) or list of structs.
  """

  @type attr_value :: any()
  @type response :: map()
  @type resource :: resource()
  @type attr_type ::
          :integer
          | :float
          | :date_time
          | {:map, Keyword.t()}
          | {:struct, module()}
          | {:list, atom(), Keyword.t() | module()}

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

  @spec parse(module :: struct(), response :: response(), resource :: resource()) :: struct()
  def parse(module, %{_embedded: %{records: records}}, resource) when is_list(records) do
    Map.put(module, :records, Enum.map(records, &resource.new/1))
  end

  def parse(module, %{}, _resource), do: module

  @spec do_parse(type :: attr_type(), value :: attr_value()) :: attr_value()
  defp do_parse(:integer, value) when is_bitstring(value), do: String.to_integer(value)

  defp do_parse(:float, value) when is_bitstring(value), do: String.to_float(value)

  defp do_parse(:date_time, value) when is_bitstring(value) do
    case DateTime.from_iso8601(value) do
      {:ok, date_time, _offset} -> date_time
      _error -> value
    end
  end

  defp do_parse({:map, mapping}, value) when is_map(value) do
    Enum.reduce(mapping, value, fn {key, type}, acc ->
      acc
      |> Map.get(key)
      |> (&do_parse(type, &1)).()
      |> (&Map.put(acc, key, &1)).()
    end)
  end

  defp do_parse({:struct, module}, value) when not is_nil(value), do: module.new(value)

  defp do_parse({:list, :map, mapping}, values) when is_list(values) do
    Enum.map(values, &do_parse({:map, mapping}, &1))
  end

  defp do_parse({:list, :struct, module}, values) when is_list(values) do
    Enum.map(values, &module.new(&1))
  end

  defp do_parse(_type, value), do: value
end
