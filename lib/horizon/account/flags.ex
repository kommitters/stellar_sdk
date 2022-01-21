defmodule Stellar.Horizon.Account.Flags do
  @moduledoc """
  Represents `Flags` for an account.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          auth_required: boolean(),
          auth_revocable: boolean(),
          auth_immutable: boolean(),
          auth_clawback_enabled: boolean()
        }

  defstruct auth_required: false,
            auth_revocable: false,
            auth_immutable: false,
            auth_clawback_enabled: false

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
