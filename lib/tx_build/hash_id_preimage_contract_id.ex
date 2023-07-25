defmodule Stellar.TxBuild.HashIDPreimageContractID do
  @moduledoc """
  `HashIDPreimageContractID` struct definition.
  """
  alias StellarBase.XDR.Hash
  alias Stellar.TxBuild.ContractIDPreimage
  alias StellarBase.XDR.HashIDPreimageContractID

  @behaviour Stellar.TxBuild.XDR

  @type network_id :: String.t()
  @type contract_id_preimage :: ContractIDPreimage.t()
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  @type t :: %__MODULE__{network_id: network_id(), contract_id_preimage: contract_id_preimage()}

  defstruct [:network_id, :contract_id_preimage]

  @impl true
  def new(args, opts \\ [])

  def new([{:network_id, network_id}, {:contract_id_preimage, contract_id_preimage}], _opts)
      when is_binary(network_id) do
    with {:ok, contract_id_preimage} <- validate_contract_id_preimage(contract_id_preimage) do
      %__MODULE__{
        network_id: network_id,
        contract_id_preimage: contract_id_preimage
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_hash_id_preimage_contract_id}

  @impl true
  def to_xdr(%__MODULE__{network_id: network_id, contract_id_preimage: contract_id_preimage}) do
    contract_id_preimage = ContractIDPreimage.to_xdr(contract_id_preimage)

    network_id
    |> Hash.new()
    |> HashIDPreimageContractID.new(contract_id_preimage)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_contract_id_preimage(contract_id_preimage :: contract_id_preimage()) ::
          validation()
  defp validate_contract_id_preimage(%ContractIDPreimage{} = contract_id_preimage),
    do: {:ok, contract_id_preimage}

  defp validate_contract_id_preimage(_contract_id_preimage),
    do: {:error, :invalid_contract_id_preimage}
end
