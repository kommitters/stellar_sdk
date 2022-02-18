defmodule Stellar.Horizon.Collection do
  @moduledoc """
  Paginates data and returns collection-based results for multiple Horizon endpoints.
  """
  alias Stellar.Horizon.CollectionError

  @type resource :: module()
  @type records :: [resource(), ...]
  @type api_response :: map()
  @type link :: String.t()
  @type args :: Keyword.t()
  @type extra_args :: list()
  @type query_string :: String.t()

  @type t :: %__MODULE__{records: records(), self: link(), prev: link(), next: link()}

  defstruct [:records, :self, :next, :prev]

  @default_args ~w(cursor order limit)a

  @spec new(response :: {resource(), api_response()}) :: t()
  def new(
        {resource,
         %{
           _embedded: %{records: records},
           _links: %{self: %{href: self}, prev: %{href: prev}, next: %{href: next}}
         }}
      ) do
    %__MODULE__{records: Enum.map(records, &resource.new/1), self: self, prev: prev, next: next}
  end

  def new(_response), do: raise(CollectionError, :invalid_collection)

  @spec query_arguments(args :: args(), extra_args :: list()) :: query_string()
  def query_arguments(args, opts \\ []) do
    extra_args = Keyword.get(opts, :extra_args, [])

    args
    |> Keyword.take(@default_args ++ extra_args)
    |> Enum.reject(&is_empty_arg/1)
    |> build_query_string()
  end

  @spec build_query_string(query :: args()) :: query_string()
  defp build_query_string([]), do: ""
  defp build_query_string(query), do: "?" <> URI.encode_query(query)

  @spec is_empty_arg(param :: {atom(), any()}) :: boolean()
  defp is_empty_arg({_key, nil}), do: true
  defp is_empty_arg({_key, value}), do: to_string(value) == ""
end
