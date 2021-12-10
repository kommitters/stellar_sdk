defmodule Stellar.TxBuild.OptionalAccount do
  @moduledoc """
  `OptionalAccount` struct definition.
  """
  alias Stellar.TxBuild.Account
  alias StellarBase.XDR.OptionalMuxedAccount

  @behaviour Stellar.TxBuild.XDR

  @type account_id :: String.t() | nil

  @type t :: %__MODULE__{account_id: account_id()}

  defstruct [:account_id]

  @impl true
  def new(account_id \\ nil, opts \\ [])

  def new(account_id, _opts) do
    %__MODULE__{account_id: account_id}
  end

  @impl true
  def to_xdr(%__MODULE__{account_id: nil}) do
    OptionalMuxedAccount.new()
  end

  def to_xdr(%__MODULE__{account_id: account_id}) do
    account_id
    |> Account.new()
    |> Account.to_xdr()
    |> OptionalMuxedAccount.new()
  end
end
