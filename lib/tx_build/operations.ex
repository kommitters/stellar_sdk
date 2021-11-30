defmodule Stellar.TxBuild.Operations do
  @moduledoc """
  `Operations` struct definition.
  """
  alias Stellar.TxBuild.Operation
  alias StellarBase.XDR.Operations

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{operations: list()}

  defstruct [:operations]

  @impl true
  def new(operations \\ [], opts \\ [])

  def new(operations, _opts) do
    %__MODULE__{operations: operations}
  end

  @impl true
  def to_xdr(%__MODULE__{operations: operations}) do
    operations
    |> Enum.map(&Operation.to_xdr/1)
    |> Operations.new()
  end

  @spec add(operations :: t(), operation :: Operation.t()) :: t()
  def add(%__MODULE__{operations: operations}, %Operation{} = operation) do
    %__MODULE__{operations: operations ++ [operation]}
  end
end
