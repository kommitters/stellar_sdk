defmodule Stellar.TxBuild.Account do
  @moduledoc """
  `Account` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.XDR.{CryptoKeyType, MuxedAccount, UInt256}

  @behaviour Stellar.TxBuild.XDR

  @type id :: integer() | nil

  @type t :: %__MODULE__{account_id: String.t(), id: id()}

  defstruct [:account_id, :id]

  @impl true
  def new(account_id, id \\ nil)

  def new(account_id, id) do
    case KeyPair.validate_ed25519_public_key(account_id) do
      :ok ->
        %__MODULE__{account_id: account_id, id: id}

      {:error, _reason} ->
        {:error, :invalid_account_id}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id}) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> MuxedAccount.new(type)
  end
end
