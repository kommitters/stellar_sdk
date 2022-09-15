defmodule Stellar.Horizon.Account.Data do
  @moduledoc """
  Represents `Data` for an account.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{value: String.t()}

  defstruct [:value]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
