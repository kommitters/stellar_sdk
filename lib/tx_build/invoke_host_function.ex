defmodule Stellar.TxBuild.InvokeHostFunction do
  @moduledoc """
  Performs the following operations:
  - Invokes contract functions.
  - Upload WASM of the new contracts.
  - Deploys new contracts using the installed WASM or built-in implementations.
  """

  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias Stellar.TxBuild.{HostFunction, OptionalAccount}

  alias StellarBase.XDR.Operations.InvokeHostFunction

  alias StellarBase.XDR.{
    HostFunctionList100,
    OperationBody,
    OperationType
  }

  @behaviour Stellar.TxBuild.XDR

  @type functions() :: list(HostFunction.t())
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{
          functions: functions(),
          source_account: OptionalAccount.t()
        }

  defstruct [:functions, :source_account]

  @impl true
  def new(functions, opts \\ [])

  def new(args, _opts) when is_list(args) do
    functions = Keyword.get(args, :functions)
    source_account = Keyword.get(args, :source_account)

    with {:ok, functions} <- validate_host_function_list(functions),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        functions: functions,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        functions: functions
      }) do
    op_type = OperationType.new(:INVOKE_HOST_FUNCTION)

    functions
    |> Enum.map(&HostFunction.to_xdr/1)
    |> HostFunctionList100.new()
    |> InvokeHostFunction.new()
    |> OperationBody.new(op_type)
  end

  @spec validate_host_function_list(functions :: functions()) :: validation()
  defp validate_host_function_list(functions) do
    if Enum.all?(functions, &is_host_function?/1),
      do: {:ok, functions},
      else: {:error, :invalid_auth_list}
  end

  @spec is_host_function?(function :: HostFunction.t()) :: boolean()
  defp is_host_function?(%HostFunction{}), do: true
  defp is_host_function?(_function), do: false
end
