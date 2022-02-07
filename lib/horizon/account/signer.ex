defmodule Stellar.Horizon.Account.Signer do
  @moduledoc """
  Represents a `Signer` for an Account.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type weight :: 0..255

  @type t :: %__MODULE__{weight: weight(), key: String.t(), type: String.t()}

  defstruct [:weight, :key, :type]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
