defmodule Stellar.TxBuild.HashIDPreimageSorobanAuthorization do
  @moduledoc """
  `HashIDPreimageSorobanAuthorization` struct definition.
  """

  alias Stellar.TxBuild.SorobanAuthorizedInvocation

  alias StellarBase.XDR.{
    Hash,
    HashIDPreimageSorobanAuthorization,
    Int64,
    UInt32
  }

  @behaviour Stellar.TxBuild.XDR

  @type network_id :: String.t()
  @type nonce :: non_neg_integer()
  @type signature_expiration_ledger :: integer()
  @type invocation :: SorobanAuthorizedInvocation.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{
          network_id: network_id(),
          nonce: nonce(),
          signature_expiration_ledger: signature_expiration_ledger(),
          invocation: invocation()
        }

  defstruct [
    :network_id,
    :nonce,
    :signature_expiration_ledger,
    :invocation
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    network_id = Keyword.get(args, :network_id)
    nonce = Keyword.get(args, :nonce)
    signature_expiration_ledger = Keyword.get(args, :signature_expiration_ledger)
    invocation = Keyword.get(args, :invocation)

    with {:ok, network_id} <- validate_network_id(network_id),
         {:ok, nonce} <- validate_nonce(nonce),
         {:ok, signature_expiration_ledger} <-
           validate_signature_expiration_ledger(signature_expiration_ledger),
         {:ok, invocation} <- validate_invocation(invocation) do
      %__MODULE__{
        network_id: network_id,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: invocation
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_preimage_soroban_auth}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: invocation
      }) do
    nonce = Int64.new(nonce)
    signature_expiration_ledger = UInt32.new(signature_expiration_ledger)
    invocation = SorobanAuthorizedInvocation.to_xdr(invocation)

    network_id
    |> Hash.new()
    |> HashIDPreimageSorobanAuthorization.new(nonce, signature_expiration_ledger, invocation)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_revoke_id}

  @spec validate_network_id(network_id :: binary()) :: validation()
  defp validate_network_id(network_id) when is_binary(network_id), do: {:ok, network_id}
  defp validate_network_id(_network_id), do: {:error, :invalid_network_id}

  @spec validate_nonce(nonce :: integer()) :: validation()
  defp validate_nonce(nonce) when is_integer(nonce), do: {:ok, nonce}
  defp validate_nonce(_nonce), do: {:error, :invalid_nonce}

  @spec validate_signature_expiration_ledger(signature_expiration_ledger :: integer()) ::
          validation()
  defp validate_signature_expiration_ledger(signature_expiration_ledger)
       when is_integer(signature_expiration_ledger),
       do: {:ok, signature_expiration_ledger}

  defp validate_signature_expiration_ledger(_signature_expiration_ledger),
    do: {:error, :invalid_signature_expiration_ledger}

  @spec validate_invocation(invocation :: invocation()) :: validation()
  defp validate_invocation(%SorobanAuthorizedInvocation{} = invocation), do: {:ok, invocation}
  defp validate_invocation(_invocation), do: {:error, :invalid_invocation}
end
