defmodule Stellar.TxBuild.HashIDPreimageCreateContractArgs do
  @moduledoc """
  `HashIDPreimageCreateContractArgs` struct definition.
  """

  alias StellarBase.XDR.{HashIDPreimageCreateContractArgs, Hash, UInt256}
  alias Stellar.TxBuild.SCContractCode

  @type t :: %__MODULE__{
          network_id: binary(),
          source: SCContractCode.t(),
          salt: non_neg_integer()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :source, :salt]

  @impl true
  def new(args, opts \\ nil)

  def new(
        [
          network_id,
          %SCContractCode{} = source,
          salt
        ],
        _opts
      )
      when is_binary(network_id) and is_integer(salt) and salt >= 0 do
    %__MODULE__{
      network_id: network_id,
      source: source,
      salt: salt
    }
  end

  def new(_args, _opts), do: {:error, :invalid_hash_id_preimage_contract_args}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        source: source,
        salt: salt
      }) do
    network_id = Hash.new(network_id)
    source = SCContractCode.to_xdr(source)
    salt = UInt256.new(salt)

    HashIDPreimageCreateContractArgs.new(network_id, source, salt)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_hash_id_preimage_contract_args}
end
