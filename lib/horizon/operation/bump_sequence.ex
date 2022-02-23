defmodule Stellar.Horizon.Operation.BumpSequence do
  @moduledoc """
  Represents a `BumpSequence` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{bump_to: String.t()}

  defstruct [:bump_to]

  @mapping [bump_to: :integer]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
