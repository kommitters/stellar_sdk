defmodule Stellar.TxBuild.AuthorizedInvocation do
  @moduledoc """
  `AuthorizedInvocation` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_sc_vals: 1,
      validate_contract_id: 1,
      validate_string: 1,
      is_struct?: 2
    ]

  alias StellarBase.XDR.{AuthorizedInvocation, AuthorizedInvocationList, Hash, SCSymbol, SCVec}
  alias Stellar.TxBuild.SCVal

  @type error :: Keyword.t() | atom()
  @type validation :: {:ok, any()} | {:error, error()}
  @type authorized_invocation_list :: AuthorizedInvocationList.t()
  @type t :: %__MODULE__{
          contract_id: binary(),
          function_name: String.t(),
          args: list(SCVal.t()),
          sub_invocations: list(t())
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:contract_id, :function_name, :args, :sub_invocations]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    contract_id = Keyword.get(args, :contract_id)
    function_name = Keyword.get(args, :function_name)
    sub_invocations = Keyword.get(args, :sub_invocations)
    args = Keyword.get(args, :args)

    with {:ok, contract_id} <- validate_contract_id({:contract_id, contract_id}),
         {:ok, function_name} <- validate_string({:function_name, function_name}),
         {:ok, args} <- validate_sc_vals({:args, args}),
         {:ok, sub_invocations} <- validate_sub_invocations({:sub_invocations, sub_invocations}) do
      %__MODULE__{
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: sub_invocations
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_authorized_invocation}

  @impl true
  def to_xdr(%__MODULE__{
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: sub_invocations
      }) do
    contract_id =
      contract_id
      |> Base.decode16!(case: :lower)
      |> Hash.new()

    function_name = SCSymbol.new(function_name)
    args = args |> Enum.map(&SCVal.to_xdr/1) |> SCVec.new()

    sub_invocations =
      sub_invocations |> Enum.map(&__MODULE__.to_xdr/1) |> AuthorizedInvocationList.new()

    AuthorizedInvocation.new(contract_id, function_name, args, sub_invocations)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_authorized_invocation}

  @spec validate_sub_invocations(tuple :: tuple()) :: validation()
  defp validate_sub_invocations({field, args}) when is_list(args) do
    if Enum.all?(args, &is_struct?(&1, __MODULE__)),
      do: {:ok, args},
      else: {:error, :"invalid_#{field}"}
  end

  defp validate_sub_invocations({field, _args}), do: {:error, :"invalid_#{field}"}
end
