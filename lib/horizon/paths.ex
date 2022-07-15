defmodule Stellar.Horizon.Paths do
  @moduledoc """
  Represents a `Payments Paths` struct.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping
  alias Stellar.Horizon.Path

  @type t :: %__MODULE__{records: list(Path.t())}

  defstruct [:records]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.parse(%__MODULE__{}, attrs, Path)
  end
end
