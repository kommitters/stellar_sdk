defmodule Stellar.Horizon.Path do
  @moduledoc """
  Represents a `Path` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          source_asset_type: String.t(),
          source_asset_code: String.t(),
          source_asset_issuer: String.t(),
          source_amount: String.t(),
          destination_asset_type: String.t(),
          destination_asset_code: String.t(),
          destination_asset_issuer: String.t(),
          destination_amount: String.t(),
          path: list(map())
        }

  defstruct [
    :source_asset_type,
    :source_asset_code,
    :source_asset_issuer,
    :source_amount,
    :destination_asset_type,
    :destination_asset_code,
    :destination_asset_issuer,
    :destination_amount,
    :path
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
