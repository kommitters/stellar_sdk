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

  def new([{type, value}], _opts)
      when type in ~w(wasm_ref token)a do
    with {:ok, _value} <- validate_sc_contract_code({type, value}) do
      %__MODULE__{
        type: type,
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

  def to_xdr(%__MODULE__{type: :token, value: value}) do
    type = SCContractCodeType.new(:SCCONTRACT_CODE_TOKEN)

    value
    |> Void.new()
    |> SCContractCode.new(type)
  end

  def to_xdr(_error), do: {:error, :invalid_sc_contract_code}

  @spec validate_sc_contract_code(tuple()) :: validation()
  defp validate_sc_contract_code({:wasm_ref, value}) when is_binary(value), do: {:ok, value}
  defp validate_sc_contract_code({:token, value}) when is_binary(value), do: {:ok, value}

  defp validate_sc_contract_code({:wasm_ref, _value}), do: {:error, :invalid_contract_hash}
  defp validate_sc_contract_code({:token, _value}), do: {:error, :invalid_contract_hash}
end
