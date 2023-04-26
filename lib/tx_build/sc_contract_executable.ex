defmodule Stellar.TxBuild.SCContractExecutable do
  @moduledoc """
  `SCContractExecutable` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{Hash, SCContractExecutable, SCContractExecutableType, Void}

  @type type :: :wasm_ref | :token
  @type value :: binary() | :token
  @type validation :: {:ok, value()} | {:error, atom()}
  @type t :: %__MODULE__{
          type: type(),
          value: value()
        }

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new(:token, _opts), do: %__MODULE__{type: :token, value: nil}

  def new([{:wasm_ref, value}], _opts) do
    with {:ok, _value} <- validate_sc_contract_executable({:wasm_ref, value}) do
      %__MODULE__{
        type: :wasm_ref,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sc_contract_executable}

  @impl true
  def to_xdr(%__MODULE__{type: :wasm_ref, value: value}) do
    type = SCContractExecutableType.new(:SCCONTRACT_EXECUTABLE_WASM_REF)

    value
    |> Hash.new()
    |> SCContractExecutable.new(type)
  end

  def to_xdr(%__MODULE__{type: :token, value: nil}) do
    type = SCContractExecutableType.new(:SCCONTRACT_EXECUTABLE_TOKEN)
    void = Void.new()

    SCContractExecutable.new(void, type)
  end

  def to_xdr(_error), do: {:error, :invalid_sc_contract_executable}

  @spec validate_sc_contract_executable(tuple()) :: validation()
  defp validate_sc_contract_executable({:wasm_ref, value}) when is_binary(value), do: {:ok, value}

  defp validate_sc_contract_executable({:wasm_ref, _value}), do: {:error, :invalid_contract_hash}
end
