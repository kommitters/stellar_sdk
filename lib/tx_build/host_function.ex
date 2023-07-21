defmodule Stellar.TxBuild.HostFunction do
  @moduledoc """
    `HostFunction` struct definition.
  """
  alias Stellar.TxBuild.{CreateContractArgs, SCVec, VariableOpaque}
  alias StellarBase.XDR.HostFunction
  alias StellarBase.XDR.HostFunctionType

  @behaviour Stellar.TxBuild.XDR

  @type value :: CreateContractArgs.t() | SCVec.t() | VariableOpaque.t()
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type type ::
          :invoke_contract
          | :create_contract
          | :upload_contract_wasm
  @type t :: %__MODULE__{
          type: type(),
          value: value()
        }

  defstruct [:type, :value]

  @allowed_types ~w(invoke_contract create_contract upload_contract_wasm)a

  @impl true
  def new(args, opts \\ [])

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, _value} <- validate_host_function({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        type: :invoke_contract,
        value: value
      }) do
    type = HostFunctionType.new(:HOST_FUNCTION_TYPE_INVOKE_CONTRACT)

    value
    |> SCVec.to_xdr()
    |> HostFunction.new(type)
  end

  def to_xdr(%__MODULE__{
        type: :create_contract,
        value: value
      }) do
    type = HostFunctionType.new(:HOST_FUNCTION_TYPE_CREATE_CONTRACT)

    value
    |> CreateContractArgs.to_xdr()
    |> HostFunction.new(type)
  end

  def to_xdr(%__MODULE__{
        type: :upload_contract_wasm,
        value: value
      }) do
    type = HostFunctionType.new(:HOST_FUNCTION_TYPE_UPLOAD_CONTRACT_WASM)

    value
    |> VariableOpaque.to_xdr()
    |> HostFunction.new(type)
  end

  @spec validate_host_function({type :: atom(), value :: value()}) :: validation()
  defp validate_host_function({:invoke_contract, %SCVec{} = value}), do: {:ok, value}
  defp validate_host_function({:create_contract, %CreateContractArgs{} = value}), do: {:ok, value}

  defp validate_host_function({:upload_contract_wasm, %VariableOpaque{} = value}),
    do: {:ok, value}

  defp validate_host_function({type, _value}), do: {:error, :"invalid_#{type}"}
end
