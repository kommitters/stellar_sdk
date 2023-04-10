defmodule Stellar.TxBuild.AuthorizedInvocation do
  @moduledoc """
  `AuthorizedInvocation` struct definition.
  """

  alias StellarBase.XDR.{AuthorizedInvocation, AuthorizedInvocationList, Hash, SCSymbol, SCVec}
  alias Stellar.TxBuild.SCVal

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

  def new(
        [
          contract_id,
          function_name,
          [%SCVal{} | _] = args,
          [] = sub_invocations
        ],
        _opts
      )
      when is_binary(contract_id) and is_binary(function_name) do
    %__MODULE__{
      contract_id: contract_id,
      function_name: function_name,
      args: args,
      sub_invocations: sub_invocations
    }
  end

  def new(
        [
          contract_id,
          function_name,
          [%SCVal{} | _] = args,
          [%__MODULE__{} | _] = sub_invocations
        ],
        _opts
      )
      when is_binary(contract_id) and is_binary(function_name) do
    %__MODULE__{
      contract_id: contract_id,
      function_name: function_name,
      args: args,
      sub_invocations: sub_invocations
    }
  end

  def new(_args, _opts), do: {:error, :invalid_authorized_invocation}

  @impl true
  def to_xdr(%__MODULE__{
        contract_id: contract_id,
        function_name: function_name,
        args: args,
        sub_invocations: sub_invocations
      }) do
    contract_id = Hash.new(contract_id)
    function_name = SCSymbol.new(function_name)
    args = args |> Enum.map(&SCVal.to_xdr/1) |> SCVec.new()
    sub_invocations = format_authorized_invocations(sub_invocations, [])

    AuthorizedInvocation.new(contract_id, function_name, args, sub_invocations)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_authorized_invocation}

  defp format_authorized_invocations([], invocation_list),
    do: AuthorizedInvocationList.new(invocation_list)

  defp format_authorized_invocations([auth_invocation | rest], invocation_list),
    do:
      format_authorized_invocations(rest, invocation_list ++ [__MODULE__.to_xdr(auth_invocation)])
end
