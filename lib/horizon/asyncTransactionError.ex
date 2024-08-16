defmodule Stellar.Horizon.AsyncTransactionError do
  @moduledoc """
  Represents a `Asynchronous transaction error` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          hash: String.t() | nil,
          tx_status: String.t() | nil,
          errorResultXdr: String.t() | nil
        }

  defstruct [
    :hash,
    :tx_status,
    :errorResultXdr
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts), do: Mapping.build(%__MODULE__{}, attrs)
end
