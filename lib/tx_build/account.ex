defmodule Stellar.TxBuild.Account do
  @moduledoc """
  `Account` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.XDR.{CryptoKeyType, MuxedAccount, MuxedAccountMed25519, UInt64, UInt256}

  @behaviour Stellar.TxBuild.XDR

  @type address :: String.t()
  @type account_id :: String.t()
  @type muxed_id :: integer() | nil
  @type type :: :ed25519_public_key | :ed25519_muxed_account
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  @type t :: %__MODULE__{
          address: address(),
          account_id: account_id(),
          muxed_id: muxed_id(),
          type: type()
        }

  defstruct [:address, :account_id, :muxed_id, :type]

  @impl true
  def new(address, opts \\ [])

  def new(address, _opts) when byte_size(address) == 69 do
    with {:ok, address} <- validate_muxed_address(address),
         {:ok, {account_id, muxed_id}} <- parse_muxed_address(address) do
      %__MODULE__{
        address: address,
        account_id: account_id,
        muxed_id: muxed_id,
        type: :ed25519_muxed_account
      }
    end
  end

  def new(address, _opts) when byte_size(address) == 56 do
    case validate_public_key(address) do
      {:ok, account_id} ->
        %__MODULE__{
          address: account_id,
          account_id: account_id,
          type: :ed25519_public_key
        }

      error ->
        error
    end
  end

  def new(_address, _opts), do: {:error, :invalid_ed25519_public_key}

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id, muxed_id: muxed_id, type: :ed25519_muxed_account}) do
    type = CryptoKeyType.new(:KEY_TYPE_MUXED_ED25519)
    ed25519_public_key_xdr = ed25519_public_key_xdr(account_id)

    muxed_id
    |> UInt64.new()
    |> MuxedAccountMed25519.new(ed25519_public_key_xdr)
    |> MuxedAccount.new(type)
  end

  def to_xdr(%__MODULE__{account_id: account_id}) do
    type = CryptoKeyType.new(:KEY_TYPE_ED25519)
    ed25519_public_key_xdr = ed25519_public_key_xdr(account_id)

    MuxedAccount.new(ed25519_public_key_xdr, type)
  end

  @spec create_muxed(account_id :: account_id(), muxed_id :: muxed_id()) :: t()
  def create_muxed(account_id, muxed_id)
      when byte_size(account_id) == 56 and is_integer(muxed_id) do
    account_id
    |> KeyPair.raw_public_key()
    |> Kernel.<>(<<muxed_id::big-unsigned-integer-size(64)>>)
    |> KeyPair.from_raw_muxed_account()
    |> new()
  end

  def create_muxed(_account_id, _id), do: {:error, :invalid_muxed_account}

  @spec validate_muxed_address(address :: address()) :: validation()
  defp validate_muxed_address(address) do
    case KeyPair.validate_muxed_account(address) do
      :ok -> {:ok, address}
      error -> error
    end
  end

  @spec validate_public_key(address :: address()) :: validation()
  defp validate_public_key(address) do
    case KeyPair.validate_public_key(address) do
      :ok -> {:ok, address}
      error -> error
    end
  end

  @spec parse_muxed_address(address :: address()) :: {:ok, {account_id(), muxed_id()}} | error()
  defp parse_muxed_address(address) do
    address
    |> KeyPair.raw_muxed_account()
    |> encode_muxed_address()
  end

  @spec encode_muxed_address(decoded_address :: binary()) ::
          {:ok, {account_id(), muxed_id()}} | error()
  defp encode_muxed_address(<<decoded::binary-size(32), muxed_id::big-unsigned-integer-size(64)>>) do
    ed25519_key = KeyPair.from_raw_public_key(decoded)
    {:ok, {ed25519_key, muxed_id}}
  end

  defp encode_muxed_address(_muxed_account), do: {:error, :invalid_muxed_address}

  @spec ed25519_public_key_xdr(account_id :: account_id()) :: UInt256.t()
  defp ed25519_public_key_xdr(account_id) do
    account_id
    |> KeyPair.raw_public_key()
    |> UInt256.new()
  end
end
