defmodule Stellar.TxBuild.Ed25519ContractID do
  @moduledoc """
  `Ed25519ContractID` struct definition.
  """

  alias StellarBase.XDR.{Ed25519ContractID, Hash, UInt256}

  @type t :: %__MODULE__{
          network_id: binary(),
          ed25519: non_neg_integer(),
          salt: non_neg_integer()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :ed25519, :salt]

  @impl true
  def new(args, opts \\ nil)

  def new(
        [
          network_id,
          ed25519,
          salt
        ],
        _opts
      )
      when is_binary(network_id) and is_integer(ed25519) and ed25519 >= 0 and is_integer(salt) and
             salt >= 0 do
    %__MODULE__{
      network_id: network_id,
      ed25519: ed25519,
      salt: salt
    }
  end

  def new(_args, _opts), do: {:error, :invalid_ed25519_contract_id}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        ed25519: ed25519,
        salt: salt
      }) do
    network_id = Hash.new(network_id)
    ed25519 = UInt256.new(ed25519)
    salt = UInt256.new(salt)

    Ed25519ContractID.new(network_id, ed25519, salt)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_ed25519_contract_id}
end
