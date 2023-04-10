defmodule Stellar.TxBuild.HashIDPreimageContractAuth do
  @moduledoc """
  `HashIDPreimageContractAuth` struct definition.
  """

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

  def new(
        [
          network_id,
          nonce,
          %AuthorizedInvocation{} = invocation
        ],
        _opts
      )
      when is_binary(network_id) and is_integer(nonce) and nonce >= 0 do
    %__MODULE__{
      network_id: network_id,
      nonce: nonce,
      invocation: invocation
    }
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
end
