defmodule Stellar.Horizon.Operation.CreateAccount do
  @moduledoc """
  Represents a `CreateAccount` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          starting_balance: String.t(),
          funder: String.t(),
          account: String.t()
        }

  defstruct [:starting_balance, :funder, :account]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
