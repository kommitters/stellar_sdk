defmodule Stellar.TxBuild.Operations do
  @moduledoc """
  `Operations` struct definition.
  """
  alias StellarBase.XDR.Operations

  @behaviour Stellar.TxBuild.Spec

  @type t :: %__MODULE__{operations: list()}

  defstruct [:operations]

  @impl true
  def new(operations \\ [], opts \\ [])

  def new(operations, _opts) do
    %__MODULE__{operations: operations}
  end

  @impl true
  def to_xdr(%__MODULE__{operations: operations}) do
    Operations.new(operations)
  end
end
