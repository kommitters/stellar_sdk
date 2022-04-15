defmodule Stellar.Horizon.Collection do
  @moduledoc """
  Paginates data and returns collection-based results for multiple Horizon endpoints.
  """
  alias Stellar.Horizon.CollectionError

  @type resource :: {module(), function()}
  @type records :: [resource(), ...]
  @type response :: map()
  @type pagination :: {function(), Keyword.t()}

  @type t :: %__MODULE__{records: records(), prev: function(), next: function()}

  defstruct [:records, :next, :prev]

  @spec new(response :: response(), resource :: resource()) :: t()
  def new(
        %{
          _embedded: %{records: records},
          _links: %{prev: %{href: prev_url}, next: %{href: next_url}}
        },
        {resource, paginate_fun}
      ) do
    %__MODULE__{
      records: Enum.map(records, &resource.new/1),
      prev: paginate({paginate_fun, prev_url}),
      next: paginate({paginate_fun, next_url})
    }
  end

  def new(_response, _resource), do: raise(CollectionError, :invalid_collection)

  @spec paginate(pagination :: pagination()) :: function()
  defp paginate({paginate_fn, url}) do
    fn ->
      url
      |> pagination_query()
      |> paginate_fn.()
    end
  end

  @spec pagination_query(url :: String.t()) :: Keyword.t()
  defp pagination_query(url) do
    case URI.parse(url) do
      %URI{query: query} when not is_nil(query) ->
        query
        |> URI.query_decoder()
        |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)

      _uri ->
        []
    end
  end
end
