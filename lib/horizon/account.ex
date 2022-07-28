defmodule Stellar.Horizon.Account do
  @moduledoc """
  Represents an `Account` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping
  alias Stellar.Horizon.Account.{Balance, Flags, Signer, Thresholds}

  @type t :: %__MODULE__{
          id: String.t(),
          account_id: String.t(),
          sequence: non_neg_integer(),
          sequence_ledger: non_neg_integer(),
          sequence_time: non_neg_integer(),
          subentry_count: non_neg_integer(),
          inflation_destination: String.t() | nil,
          home_domain: String.t() | nil,
          last_modified_ledger: non_neg_integer(),
          last_modified_time: DateTime.t(),
          num_sponsoring: non_neg_integer(),
          num_sponsored: non_neg_integer(),
          thresholds: Thresholds.t(),
          flags: Flags.t(),
          balances: list(Balance.t()),
          signers: list(Signer.t()),
          data: map(),
          paging_token: String.t()
        }

  defstruct [
    :id,
    :account_id,
    :sequence,
    :sequence_ledger,
    :sequence_time,
    :subentry_count,
    :inflation_destination,
    :home_domain,
    :last_modified_ledger,
    :last_modified_time,
    :num_sponsoring,
    :num_sponsored,
    :thresholds,
    :flags,
    :balances,
    :signers,
    :data,
    :paging_token
  ]

  @mapping [
    sequence: :integer,
    sequence_time: :integer,
    last_modified_time: :date_time,
    thresholds: {:struct, Thresholds},
    flags: {:struct, Flags},
    balances: {:list, :struct, Balance},
    signers: {:list, :struct, Signer}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
