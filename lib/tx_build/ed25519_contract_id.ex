defmodule Stellar.TxBuild.Ed25519ContractID do
  @moduledoc """
  `Ed25519ContractID` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_string: 1
    ]

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

  def new(args, _opts) when is_list(args) do
    network_id = Keyword.get(args, :network_id)
    ed25519 = Keyword.get(args, :ed25519)
    salt = Keyword.get(args, :salt)

    with {:ok, network_id} <- validate_string({:network_id, network_id}),
         {:ok, ed25519} <- validate_pos_integer({:ed25519, ed25519}),
         {:ok, salt} <- validate_pos_integer({:salt, salt}) do
      %__MODULE__{
        network_id: network_id,
        ed25519: ed25519,
        salt: salt
      }
    end
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
