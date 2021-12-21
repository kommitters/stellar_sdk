defmodule Stellar.TxBuild.OptionalAccountID do
  @moduledoc """
  `OptionalAccountID` struct definition.
  """
  alias Stellar.TxBuild.AccountID
  alias StellarBase.XDR.OptionalAccountID

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
    OptionalAccountID.new()
  end

  def to_xdr(%__MODULE__{account_id: account_id}) do
    account_id
    |> AccountID.new()
    |> AccountID.to_xdr()
    |> OptionalAccountID.new()
  end
end
