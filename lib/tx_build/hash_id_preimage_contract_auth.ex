defmodule Stellar.TxBuild.HashIDPreimageContractAuth do
  @moduledoc """
  `HashIDPreimageContractAuth` struct definition.
  """

  @type validation :: {:ok, any()} | {:error, atom()}

  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_string: 1
    ]

  alias StellarBase.XDR.{HashIDPreimageContractAuth, Hash, UInt64}
  alias Stellar.TxBuild.AuthorizedInvocation

  @type t :: %__MODULE__{
          network_id: binary(),
          nonce: non_neg_integer(),
          invocation: AuthorizedInvocation.t()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :nonce, :invocation]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    network_id = Keyword.get(args, :network_id)
    nonce = Keyword.get(args, :nonce)
    invocation = Keyword.get(args, :invocation)

    with {:ok, network_id} <- validate_string({:network_id, network_id}),
         {:ok, nonce} <- validate_pos_integer({:nonce, nonce}),
         {:ok, invocation} <- validate_authorized_invocation({:invocation, invocation}) do
      %__MODULE__{
        network_id: network_id,
        nonce: nonce,
        invocation: invocation
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_hash_id_preimage_contract_auth}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        nonce: nonce,
        invocation: invocation
      }) do
    network_id = Hash.new(network_id)
    nonce = UInt64.new(nonce)
    invocation = AuthorizedInvocation.to_xdr(invocation)

    HashIDPreimageContractAuth.new(network_id, nonce, invocation)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_hash_id_preimage_contract_auth}

  @spec validate_authorized_invocation(tuple :: tuple()) :: validation()
  def validate_authorized_invocation({_field, %AuthorizedInvocation{} = value}),
    do: {:ok, value}

  def validate_authorized_invocation({field, _}), do: {:error, :"invalid_#{field}"}
end
