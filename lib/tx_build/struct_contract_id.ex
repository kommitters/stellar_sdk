defmodule Stellar.TxBuild.StructContractID do
  @moduledoc """
  `StructContractID` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_string: 1
    ]

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

  def new(args, _opts) when is_list(args) do
    network_id = Keyword.get(args, :network_id)
    contract_id = Keyword.get(args, :contract_id)
    salt = Keyword.get(args, :salt)

    with {:ok, network_id} <- validate_string({:network_id, network_id}),
         {:ok, contract_id} <- validate_string({:contract_id, contract_id}),
         {:ok, salt} <- validate_pos_integer({:salt, salt}) do
      %__MODULE__{
        network_id: network_id,
        contract_id: contract_id,
        salt: salt
      }
    end
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
