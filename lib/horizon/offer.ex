defmodule Stellar.Horizon.Offer do
  @moduledoc """
  Represents a `Offer` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          seller: String.t(),
          selling: map(),
          buying: map(),
          amount: String.t(),
          price: String.t(),
          price_r: map(),
          last_modified_ledger: non_neg_integer(),
          last_modified_time: DateTime.t(),
          sponsor: String.t()
        }

  defstruct [
    :id,
    :paging_token,
    :seller,
    :selling,
    :buying,
    :amount,
    :price,
    :price_r,
    :last_modified_ledger,
    :last_modified_time,
    :sponsor
  ]

  @mapping [
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
