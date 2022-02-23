defmodule Stellar.Horizon.Operation.Payment do
  @moduledoc """
  Represents a `Payment` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset_type: float(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          from: String.t(),
          to: String.t(),
          amount: float()
        }

  defstruct [:asset_type, :asset_code, :asset_issuer, :from, :to, :amount]

  @mapping [amount: :float]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
