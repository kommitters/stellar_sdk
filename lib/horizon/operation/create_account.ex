defmodule Stellar.Horizon.Operation.CreateAccount do
  @moduledoc """
  Represents a `CreateAccount` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          starting_balance: float(),
          funder: String.t(),
          account: String.t()
        }

  defstruct [:starting_balance, :funder, :account]

  @mapping [starting_balance: :float]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
