defmodule Stellar.TxBuild.HostFunction do
  @moduledoc """
    `HostFunction` struct definition.
  """

  alias Stellar.TxBuild.SCVal

  alias StellarBase.XDR.SCVal, as: SCValXDR
  alias StellarBase.XDR.HostFunction, as: HostFunctionXDR

  import Stellar.TxBuild.Validations,
    only: [
      validate_sc_vals: 1,
      validate_contract_id: 1,
      validate_string: 1
    ]

  alias StellarBase.XDR.{
    SCVec,
    HostFunctionType,
    OptionalSCObject,
    SCObject,
    SCValType,
    SCSymbol,
    SCObjectType,
    VariableOpaque256000,
    SCValType
  }

  @behaviour Stellar.TxBuild.XDR

  @type type :: :invoke | :install | :create
  @type contract_id :: String.t()
  @type function_name :: String.t()
  @type invoke_args :: list(SCVal.t())
  @type args :: invoke_args()

  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{
          type: type(),
          contract_id: contract_id(),
          function_name: function_name(),
          args: args()
        }

  defstruct [:type, :contract_id, :function_name, :args]

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

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: args
      }) do
    sc_object_type = SCObjectType.new(:SCO_BYTES)
    sc_val_type = SCValType.new(:SCV_OBJECT)

    contract_id_scval =
      contract_id
      |> Base.decode16!(case: :lower)
      |> VariableOpaque256000.new()
      |> SCObject.new(sc_object_type)
      |> OptionalSCObject.new()
      |> SCValXDR.new(sc_val_type)

    sc_symbol_type = SCValType.new(:SCV_SYMBOL)

    sc_symbol_scval =
      function_name
      |> SCSymbol.new()
      |> SCValXDR.new(sc_symbol_type)

    args_scvalxdr = Enum.map(args, &SCVal.to_xdr/1)

    sc_vec =
      [contract_id_scval, sc_symbol_scval]
      |> Kernel.++(args_scvalxdr)
      |> SCVec.new()

    host_function_type = HostFunctionType.new()
    HostFunctionXDR.new(sc_vec, host_function_type)
  end
end
