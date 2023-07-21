defmodule Stellar.TxBuild.InvokeHostFunction do
  @moduledoc """
  Performs the following operations:
  - Invokes contract host_functions.
  - Upload WASM of the new contracts.
  - Deploys new contracts using the uploaded WASM or built-in implementations.
  """

  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias Stellar.TxBuild.{HostFunction, SorobanAuthorizationEntry, OptionalAccount}

  alias StellarBase.XDR.Operations.InvokeHostFunction

  alias StellarBase.XDR.{
    OperationBody,
    OperationType,
    SorobanAuthorizationEntryList
  }

  alias StellarBase.XDR.SorobanAuthorizationEntry, as: SorobanAuthorizationEntryXDR

  @behaviour Stellar.TxBuild.XDR

  @type auths :: list(SorobanAuthorizationEntry.t()) | list(String.t())
  @type error :: {:error, atom()}
  @type host_function :: HostFunction.t()
  @type soroban_auth_xdr :: SorobanAuthorizationEntryXDR.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{
          host_function: host_function(),
          auths: auths(),
          source_account: OptionalAccount.t()
        }

  defstruct [:host_function, :auths, :source_account]

  @impl true
  def new(host_function, opts \\ [])

  def new(args, _opts) when is_list(args) do
    host_function = Keyword.get(args, :host_function)
    auths = Keyword.get(args, :auths, [])
    source_account = Keyword.get(args, :source_account)

    with {:ok, host_function} <- validate_host_host_function(host_function),
         {:ok, auths} <- validate_soroban_auth_entries(auths),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        host_function: host_function,
        auths: auths,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        host_function: host_function,
        auths: [%SorobanAuthorizationEntry{} | _] = auths
      }) do
    op_type = OperationType.new(:INVOKE_HOST_FUNCTION)
    SCEC_INTERNAL_ERROR

    auth =
      auths
      |> Enum.map(&SorobanAuthorizationEntry.to_xdr/1)
      |> SorobanAuthorizationEntryList.new()

    host_function
    |> HostFunction.to_xdr()
    |> InvokeHostFunction.new(auth)
    |> OperationBody.new(op_type)
  end

  def to_xdr(%__MODULE__{
        host_function: host_function,
        auths: auths
      })
      when is_list(auths) do
    op_type = OperationType.new(:INVOKE_HOST_FUNCTION)

    auth =
      auths
      |> Enum.map(&decode_soroban_auth/1)
      |> SorobanAuthorizationEntryList.new()

    host_function
    |> HostFunction.to_xdr()
    |> InvokeHostFunction.new(auth)
    |> OperationBody.new(op_type)
  end

  @spec set_auth(module :: t(), auths :: auths()) :: t() | error()
  def set_auth(%__MODULE__{} = module, auths) when is_list(auths) do
    with {:ok, auths} <- validate_auth_strings(auths) do
      %{module | auths: auths}
    end
  end

  def set_auth(_module, _auths), do: {:error, :invalid_auth}

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

  @spec validate_host_host_function(host_function :: host_function()) :: validation()
  defp validate_host_host_function(%HostFunction{} = host_function), do: {:ok, host_function}
  defp validate_host_host_function(_host_function), do: {:error, :invalid_host_host_function}

  defp validate_soroban_auth_entries(auths) when is_list(auths) do
    if Enum.all?(auths, &is_soroban_auth_entry?/1),
      do: {:ok, auths},
      else: {:error, :invalid_soroban_auth_entries}
  end

  defp validate_soroban_auth_entries(_auths), do: {:error, :invalid_soroban_auth_entries}

  defp is_soroban_auth_entry?(%SorobanAuthorizationEntry{}), do: true
  defp is_soroban_auth_entry?(_auth), do: false

  @spec decode_soroban_auth(auth :: String.t()) :: soroban_auth_xdr()
  defp decode_soroban_auth(auth) do
    {contract_auth, ""} =
      auth
      |> Base.decode64!()
      |> SorobanAuthorizationEntryXDR.decode_xdr!()

    contract_auth
  end
end
