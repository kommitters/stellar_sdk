defmodule Stellar.TxBuild.AccountID do
  @moduledoc """
  `AccountID` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.XDR.{AccountID, PublicKey, PublicKeyType, UInt256}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{account_id: String.t()}

  defstruct [:account_id]

  @impl true
  def new(account_id, opts \\ [])

  def new(account_id, _opts) do
    case KeyPair.validate_ed25519_public_key(account_id) do
      :ok -> %__MODULE__{account_id: account_id}
      {:error, _reason} -> {:error, :invalid_account_id}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id}) do
    type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> PublicKey.new(type)
    |> AccountID.new()
  end
end
