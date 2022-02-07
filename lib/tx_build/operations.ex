defmodule Stellar.TxBuild.Operations do
  @moduledoc """
  `Operations` struct definition.
  """
  alias Stellar.TxBuild.Operation
  alias StellarBase.XDR.Operations

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{operations: list(Operation.t()), count: non_neg_integer()}

  defstruct [:operations, :count]

  @impl true
  def new(operations \\ [], opts \\ [])

  def new(operations, _opts) do
    %__MODULE__{operations: operations, count: 0}
  end

  @impl true
  def to_xdr(%__MODULE__{operations: operations}) do
    operations
    |> Enum.map(&Operation.to_xdr/1)
    |> Operations.new()
  end

  @spec add(operations :: t(), operation :: Operation.t()) :: t()
  def add(%__MODULE__{operations: operations, count: count}, %Operation{} = operation) do
    %__MODULE__{operations: operations ++ [operation], count: count + 1}
  end
end
