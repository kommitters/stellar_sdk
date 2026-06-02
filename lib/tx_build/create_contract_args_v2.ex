defmodule Stellar.TxBuild.CreateContractArgsV2 do
  @moduledoc """
  `CreateContractArgsV2` struct definition for Protocol 22+.
  """
  alias StellarBase.XDR.CreateContractArgsV2
  alias Stellar.TxBuild.{ContractExecutable, ContractIDPreimage, SCVal}

  @behaviour Stellar.TxBuild.XDR

  @type contract_id_preimage :: ContractIDPreimage.t()
  @type contract_executable :: ContractExecutable.t()
  @type constructor_args :: list(SCVal.t())
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  @type t :: %__MODULE__{
          contract_id_preimage: contract_id_preimage(),
          contract_executable: contract_executable(),
          constructor_args: constructor_args()
        }

  defstruct [:contract_id_preimage, :contract_executable, :constructor_args]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    contract_id_preimage = Keyword.get(args, :contract_id_preimage)
    contract_executable = Keyword.get(args, :contract_executable)
    constructor_args = Keyword.get(args, :constructor_args, [])

    with {:ok, contract_id_preimage} <-
           validate_contract_id_preimage(contract_id_preimage),
         {:ok, contract_executable} <- validate_contract_executable(contract_executable),
         {:ok, constructor_args} <- validate_constructor_args(constructor_args) do
      %__MODULE__{
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable,
        constructor_args: constructor_args
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_args}

  @impl true
  def to_xdr(%__MODULE__{
        contract_id_preimage: contract_id_preimage,
        contract_executable: contract_executable,
        constructor_args: constructor_args
      }) do
    contract_executable_xdr = ContractExecutable.to_xdr(contract_executable)
    contract_id_preimage_xdr = ContractIDPreimage.to_xdr(contract_id_preimage)

    constructor_args_xdr =
      constructor_args
      |> Enum.map(&SCVal.to_xdr/1)
      |> StellarBase.XDR.SCValList.new()

    CreateContractArgsV2.new(
      contract_id_preimage_xdr,
      contract_executable_xdr,
      constructor_args_xdr
    )
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

  @spec validate_constructor_args(constructor_args :: constructor_args()) :: validation()
  defp validate_constructor_args(constructor_args) when is_list(constructor_args) do
    if Enum.all?(constructor_args, &is_sc_val?/1),
      do: {:ok, constructor_args},
      else: {:error, :invalid_constructor_args}
  end

  defp validate_constructor_args(_constructor_args), do: {:error, :invalid_constructor_args}

  @spec is_sc_val?(value :: any()) :: boolean()
  defp is_sc_val?(%SCVal{}), do: true
  defp is_sc_val?(_), do: false
end
