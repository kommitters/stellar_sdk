defmodule Stellar.TxBuild.RevokeSponsorshipSigner do
  @moduledoc """
  `RevokeSponsorshipSigner` struct definition.
  """
  alias Stellar.TxBuild.{AccountID, SignerKey}
  alias StellarBase.XDR.RevokeSponsorshipSigner

  @behaviour Stellar.TxBuild.XDR

  @type account_id :: String.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{account_id: AccountID.t(), signer_key: SignerKey.t()}

  defstruct [:account_id, :signer_key]

  @impl true
  def new(args, opts \\ [])

  def new({account_id, signer_key}, _opts) do
    with {:ok, signer_key} <- validate_signer_key(signer_key),
         {:ok, account_id} <- validate_account_id(account_id) do
      %__MODULE__{account_id: account_id, signer_key: signer_key}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sponsorship_signer}

  @impl true
  def to_xdr(%__MODULE__{account_id: account_id, signer_key: signer_key}) do
    signer_key_xdr = SignerKey.to_xdr(signer_key)

    account_id
    |> AccountID.to_xdr()
    |> RevokeSponsorshipSigner.new(signer_key_xdr)
  end

  @spec validate_account_id(account_id :: account_id()) :: validation()
  defp validate_account_id(account_id) do
    case AccountID.new(account_id) do
      %AccountID{} = account_id -> {:ok, account_id}
      _error -> {:error, :invalid_account_id}
    end
  end

  @spec validate_signer_key(signer_key :: account_id()) :: validation()
  defp validate_signer_key(signer_key) do
    case SignerKey.new(signer_key) do
      %SignerKey{} = signer_key -> {:ok, signer_key}
      _error -> {:error, :invalid_signer_key}
    end
  end
end
