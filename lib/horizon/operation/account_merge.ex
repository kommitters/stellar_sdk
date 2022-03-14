defmodule Stellar.Horizon.Operation.AccountMerge do
  @moduledoc """
  Represents a `AccountMerge` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{account: String.t(), into: String.t()}

  defstruct [:account, :into]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
