defmodule Stellar.Horizon.AsyncTransaction do
  @moduledoc """
  Represents a `Asynchronous transaction` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          hash: String.t() | nil,
          tx_status: String.t() | nil
        }

  defstruct [
    :hash,
    :tx_status
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts), do: Mapping.build(%__MODULE__{}, attrs)
end
