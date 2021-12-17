defmodule Stellar.TxBuild.ClaimableBalanceID do
  @moduledoc """
  `ClaimableBalanceID` struct definition.
  """
  alias StellarBase.XDR.{ClaimableBalanceIDType, ClaimableBalanceID, Hash}

  @behaviour Stellar.TxBuild.XDR

  @type balance_id :: String.t() | binary()

  @type t :: %__MODULE__{balance_id: balance_id()}

  defstruct [:balance_id]

  @impl true
  def new(balance_id, opts \\ [])

  def new(<<_disc::binary-size(8), _arm::binary-size(64)>> = balance_id, _opts)
      when is_bitstring(balance_id) do
    %__MODULE__{balance_id: balance_id}
  end

  def new(_balance_id, _opts), do: {:error, :invalid_balance_id}

  @impl true
  def to_xdr(%__MODULE__{balance_id: balance_id}) do
    claimable_balance_id_type = ClaimableBalanceIDType.new(:CLAIMABLE_BALANCE_ID_TYPE_V0)

    balance_id
    |> (&:crypto.hash(:sha256, &1)).()
    |> Hash.new()
    |> ClaimableBalanceID.new(claimable_balance_id_type)
  end
end
