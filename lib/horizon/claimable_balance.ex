defmodule Stellar.Horizon.ClaimableBalance do
  @moduledoc """
  Represents a `ClaimableBalance` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          asset: String.t(),
          amount: float(),
          sponsor: String.t() | nil,
          last_modified_ledger: non_neg_integer(),
          last_modified_time: DateTime.t(),
          claimants: list(map())
        }

  defstruct [
    :id,
    :paging_token,
    :asset,
    :amount,
    :sponsor,
    :last_modified_ledger,
    :last_modified_time,
    :claimants
  ]

  @mapping [
    amount: :float,
    last_modified_ledger: :integer,
    last_modified_time: :date_time
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
