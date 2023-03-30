defmodule Stellar.TxBuild.HostFunction do
  @moduledoc """
  - install
  - create
  - invoke
  """

  alias Stellar.TxBuild.SCVal

  alias StellarBase.XDR.SCVal, as: SCValXDR
  alias StellarBase.XDR.HostFunction, as: HostFunctionXDR

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
    %__MODULE__{
      type: :invoke,
      contract_id: contract_id,
      function_name: function_name,
      args: args
    }
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        type: :invoke,
        contract_id: contract_id,
        function_name: function_name,
        args: args
      }) do
    scobject_type = SCObjectType.new(:SCO_BYTES)
    scval_type = SCValType.new(:SCV_OBJECT)

    contract_id_scval =
      contract_id
      |> Base.decode16!(case: :lower)
      |> VariableOpaque256000.new()
      |> SCObject.new(scobject_type)
      |> OptionalSCObject.new()
      |> SCValXDR.new(scval_type)

    scsymbol_type = SCValType.new(:SCV_SYMBOL)

    scsymbol_scval =
      function_name
      |> SCSymbol.new()
      |> SCValXDR.new(scsymbol_type)

    args_scvalxdr = Enum.map(args, &SCVal.to_xdr/1)

    sc_vec =
      [contract_id_scval, scsymbol_scval]
      |> Kernel.++(args_scvalxdr)
      |> SCVec.new()

    host_function_type = HostFunctionType.new()
    HostFunctionXDR.new(sc_vec, host_function_type)
  end
end
