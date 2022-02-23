defmodule Stellar.Horizon.Operation.AllowTrust do
  @moduledoc """
  Represents a `AllowTrust` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset_type: String.t(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          authorize: boolean(),
          trustee: String.t(),
          trustor: String.t()
        }

  defstruct [:asset_type, :asset_code, :asset_issuer, :authorize, :trustee, :trustor]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
