defmodule Stellar.TxBuild.SCContractCode do
  @moduledoc """
  `SCContractCode` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{Hash, SCContractCode, SCContractCodeType, Void}

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
    with {:ok, _value} <- validate_sc_contract_code({:wasm_ref, value}) do
      %__MODULE__{
        type: :wasm_ref,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sc_contract_code}

  @impl true
  def to_xdr(%__MODULE__{type: :wasm_ref, value: value}) do
    type = SCContractCodeType.new(:SCCONTRACT_CODE_WASM_REF)

    value
    |> Hash.new()
    |> SCContractCode.new(type)
  end

  def to_xdr(%__MODULE__{type: :token, value: nil}) do
    type = SCContractCodeType.new(:SCCONTRACT_CODE_TOKEN)
    void = Void.new()

    SCContractCode.new(void, type)
  end

  def to_xdr(_error), do: {:error, :invalid_sc_contract_code}

  @spec validate_sc_contract_code(tuple()) :: validation()
  defp validate_sc_contract_code({:wasm_ref, value}) when is_binary(value), do: {:ok, value}

  defp validate_sc_contract_code({:wasm_ref, _value}), do: {:error, :invalid_contract_hash}
end
