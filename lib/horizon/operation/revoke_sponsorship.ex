defmodule Stellar.Horizon.Operation.RevokeSponsorship do
  @moduledoc """
  Represents a `RevokeSponsorship` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type optional :: String.t() | nil

  @type t :: %__MODULE__{
          account_id: String.t(),
          claimable_balance_id: String.t(),
          data_account_id: String.t(),
          data_name: String.t(),
          offer_id: String.t(),
          trustline_account_id: String.t(),
          trustline_asset: String.t(),
          signer_account_id: String.t(),
          signer_key: String.t()
        }

  defstruct [
    :account_id,
    :claimable_balance_id,
    :data_account_id,
    :data_name,
    :offer_id,
    :trustline_account_id,
    :trustline_asset,
    :signer_account_id,
    :signer_key
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
