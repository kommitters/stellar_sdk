defmodule Stellar.Horizon.Operation.ChangeTrust do
  @moduledoc """
  Represents a `ChangeTrust` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset_type: String.t(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          limit: String.t(),
          trustee: String.t(),
          trustor: String.t(),
          liquidity_pool_id: String.t()
        }

  defstruct [
    :asset_type,
    :asset_code,
    :asset_issuer,
    :limit,
    :trustee,
    :trustor,
    :liquidity_pool_id
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
