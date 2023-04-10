defmodule Stellar.TxBuild.StructContractID do
  @moduledoc """
  `StructContractID` struct definition.
  """

  alias StellarBase.XDR.{StructContractID, Hash, UInt256}

  @type t :: %__MODULE__{
          network_id: binary(),
          contract_id: binary(),
          salt: non_neg_integer()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :contract_id, :salt]

  @impl true
  def new(args, opts \\ nil)

  def new(
        [
          network_id,
          contract_id,
          salt
        ],
        _opts
      )
      when is_binary(network_id) and is_binary(contract_id) and is_integer(salt) and salt >= 0 do
    %__MODULE__{
      network_id: network_id,
      contract_id: contract_id,
      salt: salt
    }
  end

  def new(_args, _opts), do: {:error, :invalid_struct_contract_id}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        contract_id: contract_id,
        salt: salt
      }) do
    network_id = Hash.new(network_id)
    contract_id = Hash.new(contract_id)
    salt = UInt256.new(salt)

    StructContractID.new(network_id, contract_id, salt)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_contract_id}
end
