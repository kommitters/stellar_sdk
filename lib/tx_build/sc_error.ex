defmodule Stellar.TxBuild.SCError do
  @moduledoc """
  `ScErrorCode` struct definition.
  """
  alias StellarBase.XDR.{SCError, SCErrorType, SCErrorCode, UInt32}

  @behaviour Stellar.TxBuild.XDR

  @type code ::
          :arith_domain
          | :index_bounds
          | :invalid_input
          | :missing_value
          | :existing_value
          | :exceeded_limit
          | :invalid_action
          | :internal_error
          | :unexpected_type
          | :unexpected_size
  @type type ::
          :contract
          | :wasm_vm
          | :context
          | :storage
          | :object
          | :crypto
          | :events
          | :budget
          | :code
          | :auth

  @type t :: %__MODULE__{type: type(), code: code()}

  defstruct [:type, :code]

  @types %{
    contract: :SCE_CONTRACT,
    wasm_vm: :SCE_WASM_VM,
    context: :SCE_CONTEXT,
    storage: :SCE_STORAGE,
    object: :SCE_OBJECT,
    crypto: :SCE_CRYPTO,
    events: :SCE_EVENTS,
    budget: :SCE_BUDGET,
    value: :SCE_VALUE,
    auth: :SCE_AUTH
  }

  @codes %{
    arith_domain: :SCEC_ARITH_DOMAIN,
    index_bounds: :SCEC_INDEX_BOUNDS,
    invalid_input: :SCEC_INVALID_INPUT,
    missing_value: :SCEC_MISSING_VALUE,
    existing_value: :SCEC_EXISTING_VALUE,
    exceeded_limit: :SCEC_EXCEEDED_LIMIT,
    invalid_action: :SCEC_INVALID_ACTION,
    internal_error: :SCEC_INTERNAL_ERROR,
    unexpected_type: :SCEC_UNEXPECTED_TYPE,
    unexpected_size: :SCEC_UNEXPECTED_SIZE
  }

  @impl true
  def new(args, opts \\ [])

  def new([{type, code}], _opts)
      when is_map_key(@types, type) and (is_map_key(@codes, code) or is_integer(code)) do
    %__MODULE__{type: type, code: code}
  end

  def new(_args, _opts), do: {:error, :invalid_sc_error}

  @impl true
  def to_xdr(%__MODULE__{type: :contract = type, code: code}) when is_integer(code) do
    with {:ok, type} <- retrieve_xdr_type(type) do
      type = SCErrorType.new(type)

      code
      |> UInt32.new()
      |> SCError.new(type)
    end
  end

  def to_xdr(%__MODULE__{type: type, code: code}) do
    with {:ok, type} <- retrieve_xdr_type(type),
         {:ok, code} <- retrieve_xdr_code(code) do
      type = SCErrorType.new(type)

      code
      |> SCErrorCode.new()
      |> SCError.new(type)
    end
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  defp retrieve_xdr_type(type), do: {:ok, Map.get(@types, type)}
  defp retrieve_xdr_code(code), do: {:ok, Map.get(@codes, code)}
end
