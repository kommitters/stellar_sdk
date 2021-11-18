defmodule Stellar.TxBuild.Account do
  @moduledoc """
  `Account` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.XDR.{CryptoKeyType, MuxedAccount, UInt256}

  @behaviour Stellar.TxBuild.Resource

  @type id :: nil | integer()

  @type t :: %__MODULE__{account_id: String.t(), id: id()}

  defstruct [:account_id, :id]

  @impl true
  def new(account_id, id \\ nil)

  def new(account_id, id) when byte_size(account_id) == 56 do
    %__MODULE__{account_id: account_id, id: id}
  end

  def new(_account_id, _id), do: {:error, :invalid_account_id}

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id}) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)

    account_id
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> MuxedAccount.new(type)
  end
end
