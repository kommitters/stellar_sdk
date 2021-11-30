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

  def new(account_id, _opts) when byte_size(account_id) == 56 do
    %__MODULE__{account_id: account_id}
  end

  def new(_account_id, _opts), do: {:error, :invalid_account_id}

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
