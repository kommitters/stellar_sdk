defmodule Stellar.TxBuild.Account do
  @moduledoc """
  `Account` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.XDR.{CryptoKeyType, MuxedAccount, UInt256}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, atom()}

  @type id :: integer() | nil

  @type t :: %__MODULE__{account_id: String.t(), id: id()}

  defstruct [:account_id, :id]

  @impl true
  def new(account_id, id \\ nil)

  def new(account_id, id) do
    with {:ok, account_id} <- validate_account_id(account_id),
         do: %__MODULE__{account_id: account_id, id: id}
  end

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id}) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> MuxedAccount.new(type)
  end

  @spec validate_account_id(account_id :: String.t()) :: validation()
  defp validate_account_id(account_id) do
    case KeyPair.validate_ed25519_public_key(account_id) do
      :ok -> {:ok, account_id}
      _error -> {:error, :invalid_account_id}
    end
  end
end
