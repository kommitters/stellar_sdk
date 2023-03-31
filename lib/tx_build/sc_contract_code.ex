defmodule Stellar.TxBuild.SCContractCode do
  @moduledoc """
  `SCContractCode` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{SCContractCode, SCContractCodeType}

  @type t :: %__MODULE__{
          type: SCContractCodeType.t(),
          value: SCContractCode.t()
        }

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{:wasm_ref, value}], _opts),
    do: %__MODULE__{type: :SCCONTRACT_CODE_WASM_REF, value: value}

  def new([{:token, value}], _opts), do: %__MODULE__{type: :SCCONTRACT_CODE_TOKEN, value: value}

  def new(_args, _opts), do: {:error, :invalid_sc_contract_code}

  @impl true
  def to_xdr(%__MODULE__{type: type, value: value}) do
    sc_contract_code_type = SCContractCodeType.new(type)

    SCContractCode.new(value, sc_contract_code_type)
  end
end
