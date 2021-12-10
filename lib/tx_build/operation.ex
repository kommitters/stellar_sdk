defmodule Stellar.TxBuild.Operation do
  @moduledoc """
  `Operation` struct definition.
  """
  alias Stellar.TxBuild.{CreateAccount, Payment}
  alias StellarBase.XDR.{Operation, OptionalMuxedAccount}

  @behaviour Stellar.TxBuild.XDR

  @type operation :: CreateAccount.t()

  @type source_account :: String.t() | nil

  @type t :: %__MODULE__{body: operation(), source_account: source_account()}

  defstruct [:body, :source_account]

  @impl true
  def new(body, opts \\ [])

  def new(body, _opts) do
    with :ok <- validate_operation(body) do
      %__MODULE__{body: body, source_account: body.source_account}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{body: %{__struct__: operation} = body, source_account: source_account}) do
    source_account = OptionalMuxedAccount.new(source_account)

    body
    |> operation.to_xdr()
    |> Operation.new(source_account)
  end

  @spec validate_operation(operation :: operation()) :: :ok | {:error, atom()}
  defp validate_operation(%CreateAccount{}), do: :ok
  defp validate_operation(%Payment{}), do: :ok
  defp validate_operation(_operation), do: {:error, :unknown_operation}
end
