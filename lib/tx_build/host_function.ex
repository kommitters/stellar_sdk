defmodule Stellar.TxBuild.HostFunction do
  @moduledoc """
    `HostFunction` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [
      validate_sc_vals: 1,
      validate_contract_id: 1,
      validate_string: 1
    ]

  alias Stellar.TxBuild.{Asset, SCVal, SCContractExecutable}
  alias StellarBase.XDR.HostFunction, as: HostFunctionXDR

  alias StellarBase.XDR.{
    ContractID,
    ContractIDType,
    CreateContractArgs,
    InstallContractCodeArgs,
    SCVec,
    HostFunctionType,
    UInt256,
    VariableOpaque256000
  }

  @behaviour Stellar.TxBuild.XDR

  @type type :: :invoke | :install | :create
  @type contract_id :: String.t()
  @type function_name :: String.t()
  @type invoke_args :: list(SCVal.t())
  @type args :: invoke_args()
  @type wasm_id :: binary()
  @type asset :: Asset.t()
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  @type t :: %__MODULE__{
          type: type(),
          contract_id: contract_id(),
          function_name: function_name(),
          args: args(),
          code: binary(),
          wasm_id: wasm_id(),
          salt: binary(),
          asset: asset()
        }

  defstruct [:type, :contract_id, :function_name, :args, :code, :asset, :wasm_id, :salt]

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:type, :invoke},
          {:contract_id, contract_id},
          {:function_name, function_name},
          {:args, args}
        ],
        _opts
      )
      when is_list(args) do
    with {:ok, contract_id} <- validate_contract_id({:contract_id, contract_id}),
         {:ok, function_name} <- validate_string({:function_name, function_name}),
         {:ok, args} <- validate_sc_vals({:args, args}) do
      %__MODULE__{
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: args
      }
    end
  end

  def new(
        [
          {:type, :install},
          {:code, code}
        ],
        _opts
      )
      when is_binary(code) do
    %__MODULE__{
      type: :install,
      code: code
    }
  end

  def new(
        [
          {:type, :create},
          {:wasm_id, wasm_id}
        ],
        _opts
      ) do
    new(type: :create, wasm_id: wasm_id, salt: :crypto.strong_rand_bytes(32))
  end

  def new(
        [
          {:type, :create},
          {:wasm_id, wasm_id},
          {:salt, salt}
        ],
        _opts
      ) do
    with {:ok, wasm_id} <- validate_wasm_id(wasm_id),
         {:ok, salt} <- validate_salt(salt) do
      %__MODULE__{
        type: :create,
        wasm_id: wasm_id,
        salt: salt
      }
    end
  end

  def new(
        [
          {:type, :create},
          {:asset, asset}
        ],
        _opts
      ) do
    with {:ok, _asset} <- validate_asset(asset) do
      %__MODULE__{
        type: :create,
        asset: asset
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: args
      }) do
    contract_id_scval =
      contract_id
      |> Base.decode16!(case: :lower)
      |> (&SCVal.new(bytes: &1)).()
      |> SCVal.to_xdr()

    sc_symbol_scval =
      function_name
      |> (&SCVal.new(symbol: &1)).()
      |> SCVal.to_xdr()

    args_scvalxdr = Enum.map(args, &SCVal.to_xdr/1)

    sc_vec =
      [contract_id_scval, sc_symbol_scval]
      |> Kernel.++(args_scvalxdr)
      |> SCVec.new()

    host_function_type = HostFunctionType.new()
    HostFunctionXDR.new(sc_vec, host_function_type)
  end

  def to_xdr(%__MODULE__{
        type: :install,
        code: code
      }) do
    host_function_type = HostFunctionType.new(:HOST_FUNCTION_TYPE_INSTALL_CONTRACT_CODE)

    code
    |> VariableOpaque256000.new()
    |> InstallContractCodeArgs.new()
    |> HostFunctionXDR.new(host_function_type)
  end

  def to_xdr(%__MODULE__{
        type: :create,
        wasm_id: wasm_id,
        salt: salt,
        asset: nil
      }) do
    host_function_type = HostFunctionType.new(:HOST_FUNCTION_TYPE_CREATE_CONTRACT)

    contract_id_type = ContractIDType.new(:CONTRACT_ID_FROM_SOURCE_ACCOUNT)
    contract_id = salt |> UInt256.new() |> ContractID.new(contract_id_type)

    sc_contract_executable =
      [wasm_ref: wasm_id] |> SCContractExecutable.new() |> SCContractExecutable.to_xdr()

    contract_id
    |> CreateContractArgs.new(sc_contract_executable)
    |> HostFunctionXDR.new(host_function_type)
  end

  def to_xdr(%__MODULE__{
        type: :create,
        asset: asset
      }) do
    host_function_type = HostFunctionType.new(:HOST_FUNCTION_TYPE_CREATE_CONTRACT)

    contract_id_type = ContractIDType.new(:CONTRACT_ID_FROM_ASSET)
    contract_id = asset |> Asset.to_xdr() |> ContractID.new(contract_id_type)

    sc_contract_executable = :token |> SCContractExecutable.new() |> SCContractExecutable.to_xdr()

    contract_id
    |> CreateContractArgs.new(sc_contract_executable)
    |> HostFunctionXDR.new(host_function_type)
  end

  @spec validate_asset(asset :: asset()) :: validation()
  defp validate_asset(%Asset{} = asset), do: {:ok, asset}
  defp validate_asset(_asset), do: {:error, :invalid_asset}

  @spec validate_salt(salt :: binary()) :: validation()
  defp validate_salt(salt) when is_binary(salt) and byte_size(salt) == 32, do: {:ok, salt}
  defp validate_salt(_salt), do: {:error, :invalid_salt}

  @spec validate_wasm_id(wasm_id :: binary()) :: validation()
  defp validate_wasm_id(wasm_id) when is_binary(wasm_id), do: {:ok, wasm_id}
  defp validate_wasm_id(_wasm_id), do: {:error, :invalid_wasm_id}
end
