defmodule Stellar.Horizon.Collection do
  @moduledoc """
  Paginates data and returns collection-based results for multiple Horizon endpoints.
  """
  alias Stellar.Horizon.CollectionError

  @type resource :: module()
  @type records :: [resource(), ...]
  @type response :: map()
  @type link :: String.t()

  @type t :: %__MODULE__{records: records(), self: link(), prev: link(), next: link()}

  defstruct [:records, :self, :next, :prev]

  @spec new(response :: {resource(), response()}) :: t()
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
end
