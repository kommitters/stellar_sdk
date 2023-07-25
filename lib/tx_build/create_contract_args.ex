defmodule Stellar.TxBuild.CreateContractArgs do
  @moduledoc """
  `CreateContractArgs` struct definition.
  """
  alias StellarBase.XDR.CreateContractArgs
  alias Stellar.TxBuild.{ContractExecutable, ContractIDPreimage}

  @behaviour Stellar.TxBuild.XDR

  @type contract_id_preimage :: ContractIDPreimage.t()
  @type contract_executable :: ContractExecutable.t()
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  @type t :: %__MODULE__{
          contract_id_preimage: contract_id_preimage(),
          contract_executable: contract_executable()
        }

  defstruct [:contract_id_preimage, :contract_executable]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    contract_id_preimage = Keyword.get(args, :contract_id_preimage)
    contract_executable = Keyword.get(args, :contract_executable)

    with {:ok, contract_id_preimage} <-
           validate_contract_id_preimage(contract_id_preimage),
         {:ok, contract_executable} <- validate_contract_executable(contract_executable) do
      %__MODULE__{
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_args}

  @impl true
  def to_xdr(%__MODULE__{
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable
      }) do
    contract_executable = ContractExecutable.to_xdr(contract_executable)

    contract_id_preimage
    |> ContractIDPreimage.to_xdr()
    |> CreateContractArgs.new(contract_executable)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_contract_id_preimage(contract_id_preimage :: contract_id_preimage()) ::
          validation()
  defp validate_contract_id_preimage(%ContractIDPreimage{} = contract_id_preimage),
    do: {:ok, contract_id_preimage}

  defp validate_contract_id_preimage(_contract_id_preimage),
    do: {:error, :invalid_contract_id_preimage}

  @spec validate_contract_executable(contract_executable :: contract_executable()) ::
          validation()
  defp validate_contract_executable(%ContractExecutable{} = contract_executable),
    do: {:ok, contract_executable}

  defp validate_contract_executable(_contract_executable),
    do: {:error, :invalid_contract_executable}
end
