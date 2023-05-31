defmodule Stellar.TxBuild.HostFunction do
  @moduledoc """
    `HostFunction` struct definition.
  """
  alias Stellar.TxBuild.{ContractAuth, HostFunctionArgs}
  alias StellarBase.XDR.ContractAuthList
  alias StellarBase.XDR.ContractAuth, as: ContractAuthXDR
  alias StellarBase.XDR.HostFunction, as: HostFunctionXDR

  @behaviour Stellar.TxBuild.XDR

  @type type :: :invoke | :install | :create
  @type args :: HostFunctionArgs.t()
  @type contract_auth :: ContractAuth.t()
  @type contract_auth_xdr :: ContractAuthXDR.t()
  @type auth :: list(contract_auth()) | list(String.t())
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()

  @type t :: %__MODULE__{
          args: args(),
          auth: auth()
        }

  defstruct [:args, :auth]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    function_args = Keyword.get(args, :args)
    auth = Keyword.get(args, :auth, [])

    with {:ok, args} <- validate_host_function_args(function_args),
         {:ok, auth} <- validate_host_function_auth(auth) do
      %__MODULE__{args: args, auth: auth}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        args: args,
        auth: [%ContractAuth{} | _] = auth
      })
      when is_list(auth) do
    args_xdr = HostFunctionArgs.to_xdr(args)

    contract_auth =
      auth
      |> Enum.map(&ContractAuth.to_xdr/1)
      |> ContractAuthList.new()

    HostFunctionXDR.new(args_xdr, contract_auth)
  end

  def to_xdr(%__MODULE__{
        args: args,
        auth: auth
      })
      when is_list(auth) do
    args_xdr = HostFunctionArgs.to_xdr(args)

    contract_auth =
      auth
      |> Enum.map(&decode_contract_auth/1)
      |> ContractAuthList.new()

    HostFunctionXDR.new(args_xdr, contract_auth)
  end

  @spec set_auth(module :: t(), auth :: auth()) :: t() | error()
  def set_auth(%__MODULE__{} = module, auth) when is_list(auth) do
    with {:ok, auth} <- validate_auth_strings(auth) do
      %{module | auth: auth}
    end
  end

  defp validate_auth_strings(auth) do
    if Enum.all?(auth, &validate_xdr_string/1),
      do: {:ok, auth},
      else: {:error, :invalid_auth}
  end

  @spec validate_xdr_string(xdr :: String.t() | nil) :: boolean()
  defp validate_xdr_string(nil), do: true

  defp validate_xdr_string(xdr) when is_binary(xdr) do
    case Base.decode64(xdr) do
      {:ok, _} -> true
      :error -> false
    end
  end

  @spec validate_host_function_args(args :: args()) :: validation()
  defp validate_host_function_args(%HostFunctionArgs{} = args), do: {:ok, args}
  defp validate_host_function_args(_args), do: {:error, :invalid_args}

  @spec validate_host_function_auth(auth :: auth()) :: validation()
  defp validate_host_function_auth(auth) do
    if Enum.all?(auth, &is_contract_auth?/1),
      do: {:ok, auth},
      else: {:error, :invalid_auth}
  end

  @spec is_contract_auth?(contract_auth :: contract_auth()) :: boolean()
  defp is_contract_auth?(%ContractAuth{}), do: true
  defp is_contract_auth?(_arg), do: false

  @spec decode_contract_auth(auth :: String.t()) :: contract_auth_xdr()
  defp decode_contract_auth(auth) do
    {contract_auth, ""} =
      auth
      |> Base.decode64!()
      |> ContractAuthXDR.decode_xdr!()

    contract_auth
  end
end
