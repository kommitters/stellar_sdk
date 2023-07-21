defmodule Stellar.TxBuild.SorobanAuthorizedInvocation do
  @moduledoc """
  `SorobanAuthorizedInvocation` struct definition.
  """

  alias Stellar.TxBuild.SorobanAuthorizedFunction
  alias StellarBase.XDR.{SorobanAuthorizedInvocation, SorobanAuthorizedInvocationList}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type soroban_function :: SorobanAuthorizedFunction.t()
  @type sub_invocations :: list(SorobanAuthorizedInvocation.t())

  @type t :: %__MODULE__{function: soroban_function(), sub_invocations: sub_invocations()}

  defstruct [:function, :sub_invocations]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    function = Keyword.get(args, :function)
    sub_invocations = Keyword.get(args, :sub_invocations)

    with {:ok, function} <- validate_function(function),
         {:ok, sub_invocations} <- validate_sub_invocations(sub_invocations) do
      %__MODULE__{function: function, sub_invocations: sub_invocations}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_soroban_auth_invocation}

  @impl true
  def to_xdr(%__MODULE__{function: function, sub_invocations: sub_invocations}) do
    sub_invocations =
      sub_invocations
      |> Enum.map(&to_xdr/1)
      |> SorobanAuthorizedInvocationList.new()

    function
    |> SorobanAuthorizedFunction.to_xdr()
    |> SorobanAuthorizedInvocation.new(sub_invocations)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_function(function :: soroban_function()) :: validation()
  defp validate_function(%SorobanAuthorizedFunction{} = function), do: {:ok, function}
  defp validate_function(_function), do: {:error, :invalid_function}

  @spec validate_sub_invocations(sub_invocations :: sub_invocations()) :: validation()
  defp validate_sub_invocations(sub_invocations) do
    if Enum.all?(sub_invocations, &is_soroban_auth_invocation?/1),
      do: {:ok, sub_invocations},
      else: {:error, :invalid_sub_invocations}
  end

  @spec is_soroban_auth_invocation?(t()) :: boolean()
  defp is_soroban_auth_invocation?(%__MODULE__{}), do: true
  defp is_soroban_auth_invocation?(_struct), do: false
end
