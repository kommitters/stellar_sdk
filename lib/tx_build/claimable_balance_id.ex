defmodule Stellar.TxBuild.ClaimableBalanceID do
  @moduledoc """
  `ClaimableBalanceID` struct definition.
  """
  alias StellarBase.XDR.{ClaimableBalanceIDType, ClaimableBalanceID, Hash}

  @behaviour Stellar.TxBuild.XDR

  @type balance_id :: String.t() | binary()
  @type balance_id_type :: :v0

  @type t :: %__MODULE__{balance_id: balance_id(), type: balance_id_type()}

  defstruct [:balance_id, :type]

  @impl true
  def new(balance_id, opts \\ [])

  def new(<<_balance_id_type::binary-size(8), balance_id::binary-size(64)>>, _opts)
      when is_bitstring(balance_id) do
    %__MODULE__{balance_id: balance_id, type: :v0}
  end

  def new(_balance_id, _opts), do: {:error, :invalid_balance_id}

  @impl true
  def to_xdr(%__MODULE__{balance_id: balance_id, type: :v0}) do
    claimable_balance_id_type = ClaimableBalanceIDType.new(:CLAIMABLE_BALANCE_ID_TYPE_V0)

    balance_id
    |> String.upcase()
    |> Base.decode16!()
    |> Hash.new()
    |> ClaimableBalanceID.new(claimable_balance_id_type)
  end
end
