defmodule Stellar.TxBuild.SCStatus do
  @moduledoc """
  `SCStatus` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{
    SCUnknownErrorCode,
    SCHostValErrorCode,
    SCHostObjErrorCode,
    SCHostFnErrorCode,
    SCHostStorageErrorCode,
    SCHostContextErrorCode,
    SCVmErrorCode,
    SCHostAuthErrorCode,
    SCStatusType,
    UInt32,
    Void,
    SCStatus
  }

  @type validation :: {:ok, any()} | {:error, atom()}

  @type value ::
          SCUnknownErrorCode.t()
          | SCHostValErrorCode.t()
          | SCHostObjErrorCode.t()
          | SCHostFnErrorCode.t()
          | SCHostStorageErrorCode.t()
          | SCHostContextErrorCode.t()
          | SCVmErrorCode.t()
          | SCHostAuthErrorCode.t()
          | SCStatusType.t()
          | UInt32.t()
          | Void.t()

  @type t :: %__MODULE__{
          type: String.t(),
          value: value()
        }

  @allowed_types ~w(ok unknown_error host_value_error host_object_error host_function_error host_storage_error host_context_error vm_error contract_error host_auth_error)a

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, _value} <- validate_sc_status({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sc_val_type}

  @impl true
  def to_xdr(%__MODULE__{type: :ok, value: value}) do
    type = SCStatusType.new(:SST_OK)

    value
    |> Void.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :unknown_error, value: value}) do
    type = SCStatusType.new(:SST_UNKNOWN_ERROR)

    value
    |> SCUnknownErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :host_value_error, value: value}) do
    type = SCStatusType.new(:SST_HOST_VALUE_ERROR)

    value
    |> SCHostValErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :host_object_error, value: value}) do
    type = SCStatusType.new(:SST_HOST_OBJECT_ERROR)

    value
    |> SCHostObjErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :host_function_error, value: value}) do
    type = SCStatusType.new(:SST_HOST_FUNCTION_ERROR)

    value
    |> SCHostFnErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :host_storage_error, value: value}) do
    type = SCStatusType.new(:SST_HOST_STORAGE_ERROR)

    value
    |> SCHostStorageErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :host_context_error, value: value}) do
    type = SCStatusType.new(:SST_HOST_CONTEXT_ERROR)

    value
    |> SCHostContextErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :vm_error, value: value}) do
    type = SCStatusType.new(:SST_VM_ERROR)

    value
    |> SCVmErrorCode.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract_error, value: value}) do
    type = SCStatusType.new(:SST_CONTRACT_ERROR)

    value
    |> UInt32.new()
    |> SCStatus.new(type)
  end

  def to_xdr(%__MODULE__{type: :host_auth_error, value: value}) do
    type = SCStatusType.new(:SST_HOST_AUTH_ERROR)

    value
    |> SCHostAuthErrorCode.new()
    |> SCStatus.new(type)
  end

  @spec validate_sc_status(tuple :: tuple()) :: validation()
  def validate_sc_status({:ok, nil}), do: {:ok, nil}
  def validate_sc_status({:ok, _value}), do: {:error, :invalid_void}

  def validate_sc_status({:unknown_error, value}) do
    case value |> SCUnknownErrorCode.new() |> SCUnknownErrorCode.encode_xdr() do
      {:ok, _unknown_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_unknown_error}
    end
  end

  def validate_sc_status({:host_value_error, value}) do
    case value |> SCHostValErrorCode.new() |> SCHostValErrorCode.encode_xdr() do
      {:ok, _host_value_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_host_value_error}
    end
  end

  def validate_sc_status({:host_object_error, value}) do
    case value |> SCHostObjErrorCode.new() |> SCHostObjErrorCode.encode_xdr() do
      {:ok, _host_object_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_host_object_error}
    end
  end

  def validate_sc_status({:host_function_error, value}) do
    case value |> SCHostFnErrorCode.new() |> SCHostFnErrorCode.encode_xdr() do
      {:ok, _host_function_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_host_function_error}
    end
  end

  def validate_sc_status({:host_storage_error, value}) do
    case value |> SCHostStorageErrorCode.new() |> SCHostStorageErrorCode.encode_xdr() do
      {:ok, _host_storage_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_host_storage_error}
    end
  end

  def validate_sc_status({:host_context_error, value}) do
    case value |> SCHostContextErrorCode.new() |> SCHostContextErrorCode.encode_xdr() do
      {:ok, _host_context_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_host_context_error}
    end
  end

  def validate_sc_status({:vm_error, value}) do
    case value |> SCVmErrorCode.new() |> SCVmErrorCode.encode_xdr() do
      {:ok, _vm_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_vm_error}
    end
  end

  def validate_sc_status({:contract_error, value}) do
    case value |> UInt32.new() |> UInt32.encode_xdr() do
      {:ok, _uint32} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_uint32}
    end
  end

  def validate_sc_status({:host_auth_error, value}) do
    case value |> SCHostAuthErrorCode.new() |> SCHostAuthErrorCode.encode_xdr() do
      {:ok, _host_auth_error} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_host_auth_error}
    end
  end
end
