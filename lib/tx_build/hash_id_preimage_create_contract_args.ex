defmodule Stellar.TxBuild.HashIDPreimageCreateContractArgs do
  @moduledoc """
  `HashIDPreimageCreateContractArgs` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_string: 1
    ]

  alias StellarBase.XDR.{HashIDPreimageCreateContractArgs, Hash, UInt256}
  alias Stellar.TxBuild.SCContractExecutable

  @type validation :: {:ok, any()} | {:error, atom()}
  @type t :: %__MODULE__{
          network_id: binary(),
          executable: SCContractExecutable.t(),
          salt: non_neg_integer()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :executable, :salt]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    network_id = Keyword.get(args, :network_id)
    executable = Keyword.get(args, :executable)
    salt = Keyword.get(args, :salt)

    with {:ok, network_id} <- validate_string({:network_id, network_id}),
         {:ok, executable} <- validate_contract_code({:executable, executable}),
         {:ok, salt} <- validate_pos_integer({:salt, salt}) do
      %__MODULE__{
        network_id: network_id,
        executable: executable,
        salt: salt
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_hash_id_preimage_contract_args}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        executable: executable,
        salt: salt
      }) do
    network_id = Hash.new(network_id)
    executable = SCContractExecutable.to_xdr(executable)
    salt = UInt256.new(salt)

    HashIDPreimageCreateContractArgs.new(network_id, executable, salt)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_hash_id_preimage_contract_args}

  @spec validate_contract_code(tuple :: tuple()) :: validation()
  defp validate_contract_code({_field, %SCContractExecutable{} = value}),
    do: {:ok, value}

  defp validate_contract_code({field, _}), do: {:error, :"invalid_#{field}"}
end
